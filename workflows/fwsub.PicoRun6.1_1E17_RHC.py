#!/usr/bin/env python3

import argparse

from typing import Optional

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--repo', default='SimFor2x2_v4')
    ap.add_argument('--size', type=int, default=10, help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    for name in ['PicoRun6.1a_1E17_RHC', 'PicoRun6.1b_1E17_RHC']:
        lpad = LaunchPad.auto_load()

        def make_fw(index: int, runner_postfix: str, step_postfix: str,
                    category: Optional[str]) -> Firework:

            base_env = f'{name}.{step_postfix}'
            if category is None:
                category = base_env

            spec = {
                'runner': f'{args.repo}_{runner_postfix}',
                'base_env': base_env,
                'env': {
                    'ARCUBE_OUT_NAME': f'{name}.{step_postfix}',
                    'ARCUBE_INDEX': str(index)
                },
                '_category': category
            }

            return Firework(RepoRunner(), name=f'{name}.{step_postfix}.{index:07}', spec=spec)


        for index in range(args.start, args.start + args.size):
            fw_larnd = make_fw(index, 'LArND', 'larnd', category='PR6.1_gpu')
            fw_flow = make_fw(index, 'Flow', 'flow', category='PR6.1_cpu')

            fireworks = [fw_larnd, fw_flow]

            deps = {fw_larnd: [fw_flow]}

            wf = Workflow(fireworks, deps, name=f'{name}.{index:07}')

            lpad.add_wf(wf)


if __name__ == '__main__':
    main()
