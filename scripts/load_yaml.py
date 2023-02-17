#!/usr/bin/env python3

import argparse

from fireworks.core.launchpad import LaunchPad
import ruamel.yaml as yaml

COLLECTIONS = ['repos', 'runners', 'base_envs']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('infiles', nargs='+')
    ap.add_argument('--clear', action='store_true')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]

    if args.clear:
        for collection in COLLECTIONS:
            db[collection].drop()

    for infile in args.infiles:
        data = yaml.safe_load(open(infile))

        for collection, docs in data.items():
            assert collection in COLLECTIONS
            c = db[collection]      # auto creates
            c.insert_many(docs)


if __name__ == '__main__':
    main()
