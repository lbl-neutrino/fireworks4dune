#!/usr/bin/env python3

import argparse

from typing import Optional

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner

HADD_FACTOR = 10


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MiniRun5_1E19_RHC')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimFor2x2_v4')
    ap.add_argument('--size', type=int, default=1024, help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env_prefix

    lpad = LaunchPad.auto_load()

    def make_fw(index: int, runner_postfix: str, step_postfix: str,
                category: Optional[str]) -> Firework:

        base_env = f'{args.base_env_prefix}.{step_postfix}'
        if category is None:
            category = base_env

        spec = {
            'runner': f'{args.repo}_{runner_postfix}',
            'base_env': base_env,
            'env': {
                'ARCUBE_OUT_NAME': f'{args.name}.{step_postfix}',
                'ARCUBE_INDEX': str(index)
            },
            '_category': category
        }

        return Firework(RepoRunner(), name=f'{args.name}.{step_postfix}', spec=spec)

    for i in range(args.start, args.start + args.size):
        print(i)
        fw_flow2supera = make_fw(i, 'Flow2Supera', 'flow2supera', category='cpu_minutes')
        fw_mlreco_inference = make_fw(i, 'MLreco_Inference', 'mlreco_inference',
                                      category='gpu_minutes')
        fw_mlreco_analysis = make_fw(i, 'MLreco_Analysis', 'mlreco_analysis',
                                     category='cpu_minutes')
        fw_cafmaker = make_fw(i, 'CAFmaker','caf', category='cpu_minutes')

        fireworks = [fw_flow2supera, fw_mlreco_inference, fw_mlreco_analysis,
                     fw_cafmaker]

        deps = {fw_flow2supera: [fw_mlreco_inference],
                fw_mlreco_inference: [fw_mlreco_analysis],
                fw_mlreco_analysis: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)

if __name__ == '__main__':
    main()

