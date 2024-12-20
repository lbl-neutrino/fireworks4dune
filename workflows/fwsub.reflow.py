#!/usr/bin/env python3

import argparse
import json

from fireworks import Firework, LaunchPad

from fw4dune_tasks import RepoRunner


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--runner', default='ndlar_reflow_RunFlow')
    ap.add_argument('-b', '--base-env', default='Reflow_FSD.flow')
    ap.add_argument('-i', '--inputs-json', required=True,
                    help='JSON file from ndlar_reflow/gen_input_list.py')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    assert isinstance(lpad, LaunchPad)
    assert isinstance(lpad.name, str)
    db = lpad.connection[lpad.name]

    assert db['runners'].find_one({'name': args.runner}), \
        f'Runner "{args.runner}" must exist'

    base_env_dict = db['base_envs'].find_one({'name': args.base_env})
    assert base_env_dict, \
        f'Base-env "{args.base_env}" must exist'

    with open(args.inputs_json) as f:
        envs: list[dict[str, str]] = json.load(f)

    for env in envs:
        spec = {
            'runner': args.runner,
            'base_env': args.base_env,
            'env': env,
            # See comment in fwsub.py regarding _category
            '_category': args.base_env,
        }

        fw = Firework(RepoRunner(), name=args.base_env, spec=spec)
        lpad.add_wf(fw)


if __name__ == '__main__':
    main()
