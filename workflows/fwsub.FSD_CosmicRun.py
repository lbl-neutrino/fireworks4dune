#!/usr/bin/env python3

import argparse

from typing import Optional

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner

HADD_FACTOR = 10


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='FSD_CosmicRun4')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimForFSD_v1')
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
                'ND_PRODUCTION_OUT_NAME': f'{args.name}.{step_postfix}',
                'ND_PRODUCTION_INDEX': str(index)
            },
            '_category': category
        }

        return Firework(RepoRunner(), name=f'{args.name}.{step_postfix}', spec=spec)

    for i in range(args.start, args.start + args.size):
        fw_corsika = make_fw(i, 'Corsika', 'corsika', category='cpu_seconds')
        fw_edep = make_fw(i, 'Edep', 'edep', category='cpu_seconds')
        fw_convert2h5 = make_fw(i, 'Convert2H5', 'convert2h5', category='cpu_seconds')
        fw_larnd = make_fw(i, 'LArND', 'larnd', category='gpu_minutes')
        fw_flow = make_fw(i, 'Flow', 'flow', category='cpu_minutes')
        fw_flow2supera = make_fw(i, 'Flow2Supera', 'flow2supera', category='cpu_minutes')
        fw_spine = make_fw(i, 'Spine', 'spine', category='gpu_minutes')

        fireworks = [fw_corsika, fw_edep, fw_convert2h5, fw_larnd, fw_flow,
                     fw_flow2supera, fw_spine]

        deps = {fw_corsika: [fw_edep],
                fw_edep: [fw_convert2h5],
                fw_convert2h5: [fw_larnd],
                fw_larnd: [fw_flow],
                fw_flow: [fw_flow2supera],
                fw_flow2supera: [fw_spine]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)

if __name__ == '__main__':
    main()
