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

    status = {s: fws.count_documents({'name': args.name, 'state': s})
              for s in Firework.STATE_RANKS.keys()}

    pprint.pp(status)


if __name__ == '__main__':
    main()
