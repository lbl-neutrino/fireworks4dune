#!/usr/bin/env python3

import argparse

from fireworks.core.launchpad import LaunchPad
import ruamel.yaml as yaml

COLLECTIONS = ['repos', 'runners', 'base_envs']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('infiles', nargs='+')
    args = ap.parse_args()

    for infile in args.infiles:
        data = yaml.safe_load(open(infile))

        lpad = LaunchPad.auto_load()
        db = lpad.connection[lpad.name]

        for collection, docs in data.items():
            assert collection in COLLECTIONS
            c = db[collection]      # auto creates
            c.insert_many(docs)


if __name__ == '__main__':
    main()
