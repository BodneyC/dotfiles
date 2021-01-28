#!/usr/bin/env bash

command -v jq &> /dev/null || return 1
command -v i3-msg &> /dev/null || return 1

if [[ -z "$1" ]]; then
  echo "No command specified"
  exit 1
fi

_cycle_dir="$1"

TOGGLE_FILE="/tmp/i3.toggle.indicator"
if [[ "$1" =~ "toggle" ]]; then
  if [[ ! -f "$TOGGLE_FILE" ]]; then
    echo "down" > "$TOGGLE_FILE"
  fi
  _cycle_dir="$(<"$TOGGLE_FILE")"
fi

if [[ "$_cycle_dir" == "up" ]]; then
  _toggle="down"
else
  _toggle="up"
fi
echo "$_toggle" > "$TOGGLE_FILE"

export _cycle_dir

# I'm strangely proud of this...
_i3_focused="$(i3-msg -t get_tree | jq '
  def get_containers(d):
    d | .nodes
      | map(select(.name | contains("__") | not))
      | map(.nodes) | flatten
      | map(select(.type | contains("dockarea") | not))
      | map(.nodes) | flatten
      | map(.nodes) | flatten
    ;

  def get_focused_idx(d):
    d | label $out
      | length as $len
      | foreach .[] as $item (
          -1; .+1;
          if $item.focused == true then 
            if $ENV._cycle_dir == "up" then
              if .+1 >= $len then 0 else .+1 end
            else
              if .-1 < 0 then $len - 1 else .-1 end
            end,
            break $out 
          else 
            empty
          end
        ),
        0
    ;

    get_containers(.) as $data
      | get_focused_idx($data) as $idx
      | $data | .[$idx].id
')"

# echo "$_i3_focused"

i3-msg "[con_id=\"$_i3_focused\"] focus"
