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
        pre_hadd_range = range(i*HADD_FACTOR, (i+1)*HADD_FACTOR)

        fws_genie_nu = [make_fw(j, 'Genie', 'genie.nu', category='cpu_seconds')
                        for j in pre_hadd_range]
        fws_genie_rock = [make_fw(j, 'Genie', 'genie.rock', category='cpu_hours')
                          for j in pre_hadd_range]
        fws_edep_nu = [make_fw(j, 'Edep', 'edep.nu', category='cpu_seconds')
                       for j in pre_hadd_range]
        fws_edep_rock = [make_fw(j, 'Edep', 'edep.rock', category='cpu_hours')
                         for j in pre_hadd_range]
        fw_hadd_nu = make_fw(i, 'Hadd', 'edep.nu.hadd', category='cpu_seconds')
        fw_hadd_rock = make_fw(i, 'Hadd', 'edep.rock.hadd', category='cpu_seconds')
        fw_spill = make_fw(i, 'SpillBuild', 'spill', category='cpu_seconds')
        fw_convert2h5 = make_fw(i, 'Convert2H5', 'convert2h5', category='cpu_seconds')
        fw_larnd = make_fw(i, 'LArND', 'larnd', category='gpu_minutes')
        fw_flow = make_fw(i, 'Flow', 'flow', category='cpu_minutes')
        fw_plots = make_fw(i, 'Plots', 'plots', category='cpu_minutes')

        fireworks = [*fws_genie_nu, *fws_genie_rock, *fws_edep_nu, *fws_edep_rock,
                     fw_hadd_nu, fw_hadd_rock, fw_spill, fw_convert2h5, fw_larnd,
                     fw_flow, fw_plots]

        deps = {**{fw_genie_nu: [fw_edep_nu] for fw_genie_nu, fw_edep_nu
                   in zip(fws_genie_nu, fws_edep_nu)},
                **{fw_genie_rock: [fw_edep_rock] for fw_genie_rock, fw_edep_rock
                   in zip(fws_genie_rock, fws_edep_rock)},
                **{fw_edep_nu: [fw_hadd_nu] for fw_edep_nu in fws_edep_nu},
                **{fw_edep_rock: [fw_hadd_rock] for fw_edep_rock in fws_edep_rock},
                fw_hadd_nu: [fw_spill],
                fw_hadd_rock: [fw_spill],
                fw_spill: [fw_convert2h5],
                fw_convert2h5: [fw_larnd],
                fw_larnd: [fw_flow],
                fw_flow: [fw_plots]}

        wf = Workflow(fireworks, deps)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
