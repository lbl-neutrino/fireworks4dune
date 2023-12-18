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
    ap.add_argument('--worker', help='Controls which workers can produce these files; defaults to --name')
    ap.add_argument('--size', type=int, default=1, help='Number of files to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]

    assert db['runners'].find_one({'name': args.runner}), \
        f'Runner "{args.runner}" must exist'

    base_env_dict = db['base_envs'].find_one({'name': args.base_env})
    assert base_env_dict, \
        f'Base-env "{args.base_env}" must exist'

    if args.name:
        out_name = args.name
    # NOTE: We should probably avoid putting ARCUBE_OUT_NAME in the base_env
    elif 'ARCUBE_OUT_NAME' in base_env_dict['env']:
        out_name = base_env_dict['env']['ARCUBE_OUT_NAME']
    else:
        out_name = args.base_env

    if args.worker is None:
        args.worker = args.name
        if args.worker is None:
            args.worker = args.base_env

    var_prefix = "ARCUBE_"
    if 'ND_Production' in args.runner: var_prefix = "ND_PRODUCTION_"
    for index in range(args.start, args.start + args.size):
        spec = {
            'runner': args.runner,
            'base_env': args.base_env,
            'env': {
                var_prefix+'OUT_NAME': out_name,
                var_prefix+'INDEX': str(index),
            },
            # NOTE: Setting the _category means "Workers CAN restrict themselves
            # to me by setting their `category` to this _category". Whereas
            # setting the _fworker means "Only workers whose `name` matches my
            # `_fworker` can run me". We only need to use `_category` for our
            # workflows.
            '_category': args.worker,
            # '_fworker': args.worker,
        }

        fw = Firework(RepoRunner(), name=args.worker, spec=spec)
        lpad.add_wf(fw)


if __name__ == '__main__':
    main()
