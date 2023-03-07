#!/usr/bin/env python3

import argparse
import ruamel.yaml as yaml

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--runner', required=True)
    ap.add_argument('--base-env', required=True)
    ap.add_argument('--name', help='Output dir; defaults to base_env.ARCUBE_OUT_NAME if available; otherwise --base-env')
    ap.add_argument('--worker', help='Controls which workers can produce these files; defaults to --base-env')
    ap.add_argument('--size', type=int, default=1, help='Number of files to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    if args.worker is None:
        args.worker = args.base_env

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]

    assert db['runners'].find_one({'name': args.runner}), \
        f'Runner "{args.runner}" must exist'

    base_env_dict = db['base_envs'].find_one({'name': args.base_env})
    assert base_env_dict, \
        f'Base-env "{args.base_env}" must exist'

    for index in range(args.start, args.size):
        spec = {
            'runner': args.runner,
            'base_env': args.base_env,
            'env': {
                'ARCUBE_INDEX': str(index),
            },
            '_fworker': args.worker,
            '_category': args.worker,
        }

        if args.name:
            spec['env']['ARCUBE_OUT_NAME'] = name

        elif 'ARCUBE_OUT_NAME' not in base_env_dict['env']:
            spec['env']['ARCUBE_OUT_NAME'] = args.base_env

        fw_name = args.name if args.name else args.base_env
        fw = Firework(RepoRunner(), name=fw_name, spec=spec)
        lpad.add_wf(fw)


if __name__ == '__main__':
    main()
