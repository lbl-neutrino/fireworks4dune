#!/usr/bin/env python3

import argparse
import ruamel.yaml as yaml

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--runner', required=True)
    ap.add_argument('--base-env', required=True)
    ap.add_argument('--name', help='Defaults to --base-env; controls output directory')
    ap.add_argument('--worker', help='Defaults to --name; controls which workers can produce these files')
    ap.add_argument('--size', type=int, default=1, help='Number of files to produce')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env

    if args.worker is None:
        args.worker = args.name

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]

    if not db['runners'].find_one({'name': args.runner}):
        print(f'PANIK: Runner {args.runner} does not exist')
        raise

    if not db['base_envs'].find_one({'name': args.base_env}):
        print(f'PANIK: Base-env {args.base_env} does not exist')
        raise

    for index in range(args.size):
        spec = {
            'runner': args.runner,
            'base_env': args.base_env,
            'env': {
                'ARCUBE_OUT_NAME': args.name,
                'ARCUBE_INDEX': str(index),
            },
            '_fworker': args.worker,
            '_category': args.worker,
        }

        fw = Firework(RepoRunner(), name=args.name, spec=spec)
        lpad.add_wf(fw)


if __name__ == '__main__':
    main()
