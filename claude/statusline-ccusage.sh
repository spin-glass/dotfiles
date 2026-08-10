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

line="$("$CCUSAGE" statusline $CFGOPT)"

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
  printf '%s\n' "$line" | sed "s| today /| today / ${mcost} month /|"
else
  printf '%s\n' "$line"
fi
