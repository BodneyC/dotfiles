#!/usr/bin/env bash

command -v jq &> /dev/null || return 1
command -v i3-msg &> /dev/null || return 1

TOGGLE_FILE="/tmp/i3.previous.id"

# I'm strangely proud of this...
_i3_containers="$(i3-msg -t get_tree | jq '
    . | .nodes
      | map(select(.name | contains("__") | not))
      | map(.nodes) | flatten
      | map(select(.type | contains("dockarea") | not))
      | map(.nodes) | flatten
      | map(.nodes) | flatten
')"

_current_node_id="$(jq '
  def get_focused_idx(d):
    d | label $out
      | length as $len
      | foreach .[] as $item (
          -1; .+1;
          if $item.focused == true then 
            .,
            break $out
          else 
            empty
          end
        ),
        0
    ;

  . as $data
    | get_focused_idx($data) as $idx
    | $data | .[$idx].id
' <<< "$_i3_containers")"

if [[ "$1" == "--update" ]]; then
  echo "$_current_node_id" > "$TOGGLE_FILE"
  exit 0
fi

_prev_node_id=""

if [[ -f "$TOGGLE_FILE" ]]; then
  _prev_node_id="$(<"$TOGGLE_FILE")"
  export _prev_node_id
  _prev_node_exists="$(jq '
    def does_node_exist(d):
      d | label $out
        | foreach .[] as $item (
            -1; .+1;
            if $item.id | tostring == $ENV._prev_node_id then 
              0,
              break $out 
            else 
              empty
            end
          ),
          -1
      ;

    does_node_exist(.)
  ' <<< "$_i3_containers")"
  if [[ "$_prev_node_exists" == -1 ]]; then
    echo "THE PREVIOUS NODE $_prev_node_id DOESN'T EXIST"
    _prev_node_id=""
  fi
fi

if [[ -z "$_prev_node_id" || "$_prev_node_id" == "$_current_node_id" ]]; then
  echo "in if, $_prev_node_id, $_current_node_id" >> /tmp/i3.tmp.log
  jq '
    def get_next_idx(d):
      d | label $out
        | length as $len
        | foreach .[] as $item (
            -1; .+1;
            if $item.focused == true then 
              if .+1 >= $len then 0 else .+1 end,
              break $out 
            else 
              empty
            end
          ),
          0
      ;

    . as $data
      | get_next_idx($data) as $idx
      | $data | .[$idx].id
  ' <<< "$_i3_containers" > "$TOGGLE_FILE"
fi
_prev_node_id="$(<"$TOGGLE_FILE")"

echo "$_current_node_id" > "$TOGGLE_FILE"

i3-msg "[con_id=\"$_prev_node_id\"] focus"
