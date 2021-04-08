#!/usr/bin/env python3

import sys
import json

import subprocess as sp


if (len(sys.argv) > 3 or
        sys.argv[1] not in ['up', 'down', 'update', 'toggle', 'ws']):
    print('Invalid args: ' + ' '.join(sys.argv))
    sys.exit(1)


arg = sys.argv[1]


def run_cmd(cmd):
    try:
        return sp.run(cmd, check=True, capture_output=True).stdout
    except FileNotFoundError as e:
        print(e)
        sys.exit(1)


nodes = []


def walk(node):
    def key_exists(d, k):
        if k in d:
            return d[k]
        return None

    global nodes
    for n in node:
        type = key_exists(n, 'type')
        if type and 'dockarea' not in type:
            if key_exists(n, 'nodes'):
                walk(n['nodes'])
            else:
                if key_exists(n, 'window'):
                    nodes.append(n)


walk(json.loads(run_cmd(['i3-msg', '-t', 'get_tree']))['nodes'])

toggle_fn = "/tmp/i3.previous.id"

with open(toggle_fn, 'a+') as f:
    f.seek(0)
    destination_id = f.read()


if len(nodes) > 0:
    focused_idx = [i for i, e in enumerate(nodes) if e.get('focused')]

    if focused_idx:
        focused_idx = focused_idx[0]
    else:
        focused_idx = [i for i, e in enumerate(nodes)
                       if e.get('id') == destination_id]
        if not focused_idx:
            focused_idx = 0

    with open(toggle_fn, 'w') as f:
        f.write(str(nodes[focused_idx].get('id')))

if arg == 'update':
    sys.exit(0)

elif arg == 'ws':
    if len(sys.argv) != 3:
        print('No NS val given')
        sys.exit(2)
    if all(c.isdigit() for c in sys.argv[2]):
        run_cmd(['i3-msg', 'workspace', 'number', sys.argv[2]])
    else:
        run_cmd(['i3-msg', 'workspace'] + sys.argv[2].split(' '))
    sys.exit(0)

elif arg == 'toggle':
    if not [e for i, e in enumerate(nodes)
            if str(e.get('id')) == destination_id and i != focused_idx]:
        destination_id = nodes[focused_idx - 1].get('id')

elif arg == 'up':
    destination_id = nodes[(focused_idx + 1) % len(nodes)].get('id')

elif arg == 'down':
    destination_id = nodes[focused_idx - 1].get('id')

run_cmd(['i3-msg', f'[con_id="{destination_id}"]', 'focus'])
