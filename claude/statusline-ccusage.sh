#!/bin/sh
# ccusage statusline に当月コストを追加表示するラッパー
# 月次集計は重いので 5 分キャッシュ
CCUSAGE="$HOME/.local/share/mise/shims/ccusage"
PYTHON="$HOME/.local/share/mise/shims/python3"
CACHE="$HOME/.cache/ccusage-month-cost"
# ccusage の自動探索は cwd のみのため、グローバル設定は明示指定する
CONFIG="$HOME/.claude/ccusage.json"
CFGOPT=""
[ -f "$CONFIG" ] && CFGOPT="--config $CONFIG"

INPUT=$(cat)
line="$(printf '%s' "$INPUT" | "$CCUSAGE" statusline $CFGOPT)"

# 公式レート制限(Pro/Max のみ stdin JSON に含まれる)→ 2行目に表示
RATE=$(printf '%s' "$INPUT" | "$PYTHON" -c '
import json, sys
from datetime import datetime
try:
    d = json.load(sys.stdin)
    rl = d.get("rate_limits") or {}
    wd = ["月", "火", "水", "木", "金", "土", "日"]
    parts = []
    for win, label, fmt in [("five_hour", "5h", "{h:%H:%M}"), ("seven_day", "週", "{w}{h:%H:%M}")]:
        w = rl.get(win) or {}
        p = w.get("used_percentage")
        if p is None:
            continue
        s = f"{label} {p:.0f}%"
        r = w.get("resets_at")
        if r:
            t = datetime.fromtimestamp(r)
            s += " (→" + fmt.format(h=t, w=wd[t.weekday()]) + ")"
        parts.append(s)
    print(" · ".join(parts))
except Exception:
    pass
' 2>/dev/null)

now=$(date +%s)
age=999999
[ -f "$CACHE" ] && age=$(( now - $(stat -f %m "$CACHE") ))
if [ "$age" -gt 300 ]; then
  month=$(date +%Y-%m)
  cost=$("$CCUSAGE" claude monthly --json $CFGOPT 2>/dev/null | MONTH="$month" "$PYTHON" -c '
import json, os, sys
month = os.environ["MONTH"]
data = json.load(sys.stdin)
for m in data.get("monthly", []):
    if m.get("month") == month:
        print("$%.2f" % m["totalCost"])
        break
' 2>/dev/null)
  [ -n "$cost" ] && printf '%s' "$cost" > "$CACHE"
fi

mcost=$(cat "$CACHE" 2>/dev/null)
if [ -n "$mcost" ]; then
  # "X today" の直後に月次を挿入(行末は画面幅で切れるため)
  line=$(printf '%s\n' "$line" | sed "s| today /| today / ${mcost} month /|")
fi

if [ -n "$RATE" ]; then
  printf '%s\n⏳ %s\n' "$line" "$RATE"
else
  printf '%s\n' "$line"
fi
