#!/usr/bin/env bash

command -v jq &> /dev/null || return 1
command -v i3-msg &> /dev/null || return 1

export _cycle_dir="${1:-up}"

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
