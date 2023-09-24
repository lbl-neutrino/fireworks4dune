#!/usr/bin/env python3

import argparse
import pprint

from fireworks import Firework, LaunchPad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('name')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]
    fws = db['fireworks']

    for s in Firework.STATE_RANKS.keys():
        print(f'{s}: ', end='', flush=True)
        n = fws.count_documents({'name': args.name, 'state': s})
        print(n, flush=True)


if __name__ == '__main__':
    main()
