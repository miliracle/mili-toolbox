#!/bin/sh
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

if [ -n "$used" ] && [ -n "$remaining" ]; then
  ctx=$(printf "ctx: %.0f%% used / %.0f%% left" "$used" "$remaining")
else
  ctx=""
fi

if [ -n "$five_hour" ]; then
  rate=$(printf "5h: %.0f%% used" "$five_hour")
else
  rate=""
fi

out="$model"
[ -n "$ctx" ] && out="$out  |  $ctx"
[ -n "$rate" ] && out="$out  |  $rate"
printf "%s" "$out"
