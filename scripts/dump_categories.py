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

    for cat in fws.distinct('spec._category', {'name': args.name}):
        print(cat)


if __name__ == '__main__':
    main()
