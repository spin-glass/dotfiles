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

# モデル別週次枠(Fable等)は stdin に来ないため公式 usage API から取得。
# トークンは Keychain からパイプ渡しのみ(ディスクに書かない)。2分キャッシュ、失敗時は空で静かに省略
SCOPED_CACHE="$HOME/.cache/claude-scoped-limit"
sage=999999
[ -f "$SCOPED_CACHE" ] && sage=$(( now - $(stat -f %m "$SCOPED_CACHE") ))
if [ "$sage" -gt 120 ]; then
  security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | "$PYTHON" -c '
import json, sys, urllib.request
try:
    tok = (json.load(sys.stdin).get("claudeAiOauth") or {}).get("accessToken")
    req = urllib.request.Request("https://api.anthropic.com/api/oauth/usage",
        headers={"Authorization": "Bearer " + tok, "anthropic-beta": "oauth-2025-04-20"})
    with urllib.request.urlopen(req, timeout=10) as r:
        d = json.load(r)
    parts = []
    for lim in d.get("limits") or []:
        if lim.get("kind") != "weekly_scoped" or not lim.get("is_active"):
            continue
        scope = lim.get("scope") or {}
        name = ((scope.get("model") or {}).get("display_name")
                or scope.get("surface") or "scoped")
        parts.append("%s週 %.0f%%" % (name, lim.get("percent") or 0))
    print(" · ".join(parts))
except Exception:
    pass
' > "$SCOPED_CACHE" 2>/dev/null
fi
SCOPED=$(cat "$SCOPED_CACHE" 2>/dev/null)
if [ -n "$SCOPED" ]; then
  [ -n "$RATE" ] && RATE="$RATE · $SCOPED" || RATE="$SCOPED"
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
