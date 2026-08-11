#!/usr/bin/env python3

import argparse
import sys
import subprocess
from functools import lru_cache

import yaml
from yamlinclude import YamlIncludeConstructor
YamlIncludeConstructor.add_to_loader_class(loader_class=yaml.FullLoader,
                                           relative=True,
                                           persist_anchors=True)

from fireworks.core.launchpad import LaunchPad

COLLECTIONS = ['repos', 'runners', 'base_envs']


@lru_cache(maxsize=None)
def get_container_id(container_name):
    """Returns the container ID hash using shifterimg lookup."""
    try:
        result = subprocess.check_output(['shifterimg', 'lookup', container_name],
                                         text=True, stderr=subprocess.STDOUT)
        return result.strip()
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"PANIK: Could not lookup container {container_name}: {e}")
        return container_name


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
            # flatten out any nested lists (e.g. from using !include)
            docs = [doc for d in docs
                    for doc in (d if isinstance(d, list) else [d])]

            for doc in docs:
                # Transform ND_PRODUCTION_CONTAINER if present in base_envs
                # from its name to its image ID hash and store original name
                if collection == 'base_envs' and 'env' in doc:
                    env = doc['env']
                    if 'ND_PRODUCTION_CONTAINER' in env:
                        container_name = env['ND_PRODUCTION_CONTAINER']
                        env['ND_PRODUCTION_CONTAINER_NAME'] = container_name
                        env['ND_PRODUCTION_CONTAINER'] = f"id:{get_container_id(container_name)}"

                if c.find_one({'name': doc['name']}):
                    if not args.replace:
                        print(f'PANIK: Duplicate doc {doc["name"]}; pass --replace to replace it')
                        sys.exit(1)
                    c.replace_one({'name': doc['name']}, doc)
                else:
                    c.insert_one(doc)


if __name__ == '__main__':
    main()
