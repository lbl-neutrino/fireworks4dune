#!/usr/bin/env python3

import argparse
import sys

import yaml
from yamlinclude import YamlIncludeConstructor
YamlIncludeConstructor.add_to_loader_class(loader_class=yaml.FullLoader, relative=True)

from fireworks.core.launchpad import LaunchPad

COLLECTIONS = ['repos', 'runners', 'base_envs']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('infiles', nargs='+')
    ap.add_argument('--clear', action='store_true')
    ap.add_argument('--replace', action='store_true')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]

    if args.clear:
        for collection in COLLECTIONS:
            db[collection].drop()

    for infile in args.infiles:
        with open(infile) as f:
            data = yaml.load(f, Loader=yaml.FullLoader)

        for collection, docs in data.items():
            if collection not in COLLECTIONS:
                continue
            c = db[collection]      # auto creates
            for doc in docs:
                if c.find_one({'name': doc['name']}):
                    if not args.replace:
                        print(f'PANIK: Duplicate doc {doc["name"]}; pass --replace to replace it')
                        sys.exit(1)
                    c.replace_one({'name': doc['name']}, doc)
                else:
                    c.insert_one(doc)


if __name__ == '__main__':
    main()
