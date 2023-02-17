#!/usr/bin/env python3

import argparse
import ruamel.yaml as yaml

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--runner', default='SimFor2x2_v1_GenieEdep')
    ap.add_argument('--base-env', default='SimFor2x2_v1_MiniRun1_1E19_RHC_rock_tiny')
    ap.add_argument('--name')
    # ap.add_argument('--size', default=5120)
    ap.add_argument('--size', default=64)
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()

    for index in range(args.size):
        spec = {
            'runner': args.runner,
            'base_env': args.base_env,
            'env': {
                'ARCUBE_INDEX': str(index),
            },
            '_fworker': 'fworker_edep_sim'
        }

        if args.name:
            spec['env']['ARCUBE_OUT_NAME'] = name
        # otherwise use ARCUBE_OUT_NAME from the base_env

        fw_name = args.name if args.name else args.base_env

        fw = Firework(RepoRunner(), name=fw_name, spec=spec)
        lpad.add_wf(fw)


if __name__ == '__main__':
    main()
