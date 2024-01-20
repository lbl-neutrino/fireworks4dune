#!/usr/bin/env python3

import argparse

from typing import Optional

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner

HADD_FACTOR = 10


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MegaRun5_1E20_RHC')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimFor2x2_v4')
    ap.add_argument('--size', type=int, default=10000, help='Number of final outputs (post-hadd etc.) to produce')
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

        fws_genie_nu = [make_fw(j, 'Genie', 'genie.nu', category='mega_cpu_seconds')
                        for j in pre_hadd_range]
        fws_genie_rock = [make_fw(j, 'Genie', 'genie.rock', category='mega_cpu_hours')
                          for j in pre_hadd_range]
        fws_edep_nu = [make_fw(j, 'Edep', 'edep.nu', category='mega_cpu_seconds')
                       for j in pre_hadd_range]
        fws_edep_rock = [make_fw(j, 'Edep', 'edep.rock', category='mega_cpu_hours')
                         for j in pre_hadd_range]
        fw_hadd_nu = make_fw(i, 'Hadd', 'edep.nu.hadd', category='mega_cpu_seconds')
        fw_hadd_rock = make_fw(i, 'Hadd', 'edep.rock.hadd', category='mega_cpu_seconds')
        fw_spill = make_fw(i, 'SpillBuild', 'spill', category='mega_cpu_seconds')
        fw_convert2h5 = make_fw(i, 'Convert2H5', 'convert2h5', category='mega_cpu_seconds')
        fw_larnd = make_fw(i, 'LArND', 'larnd', category='mega_gpu_minutes')
        fw_flow = make_fw(i, 'Flow', 'flow', category='mega_cpu_minutes')
        fw_edep2flat = make_fw(i, 'Edep2Flat', 'edep2flat', category='mega_cpu_minutes')
        fw_minerva = make_fw(i, 'Minerva', 'minerva', category='mega_cpu_minutes')
        fw_flow2supera = make_fw(i, 'Flow2Supera', 'mlreco', category='mega_cpu_minutes')
        fw_mlreco_inference = make_fw(i, 'MLreco_Inference', 'mlreco',
                                      category='mega_gpu_minutes')
        fw_mlreco_analysis = make_fw(i, 'MLreco_Analysis', 'mlreco',
                                     category='mega_cpu_minutes')
        fw_pandora = make_fw(i, 'Pandora', 'pandora', category='mega_cpu_minutes')
        fw_cafmaker = make_fw(i, 'CAFmaker','caf', category='mega_cpu_minutes')
        ## Keep the plots outside the workflow
        # fw_plots = make_fw(i, 'Plots', 'plots', category='mega_cpu_minutes')

        fireworks = [*fws_genie_nu, *fws_genie_rock, *fws_edep_nu, *fws_edep_rock,
                     fw_hadd_nu, fw_hadd_rock, fw_spill, fw_convert2h5, fw_larnd,
                     fw_flow, fw_edep2flat, fw_minerva,
                     fw_flow2supera, fw_mlreco_inference, fw_mlreco_analysis,
                     fw_pandora, fw_cafmaker]

        deps = {**{fw_genie_nu: [fw_edep_nu] for fw_genie_nu, fw_edep_nu
                   in zip(fws_genie_nu, fws_edep_nu)},
                **{fw_genie_rock: [fw_edep_rock] for fw_genie_rock, fw_edep_rock
                   in zip(fws_genie_rock, fws_edep_rock)},
                **{fw_edep_nu: [fw_hadd_nu] for fw_edep_nu in fws_edep_nu},
                **{fw_edep_rock: [fw_hadd_rock] for fw_edep_rock in fws_edep_rock},
                fw_hadd_nu: [fw_spill],
                fw_hadd_rock: [fw_spill],
                fw_spill: [fw_convert2h5, fw_edep2flat],
                fw_edep2flat: [fw_minerva],
                fw_minerva: [fw_cafmaker],
                fw_convert2h5: [fw_larnd],
                fw_larnd: [fw_flow],
                fw_flow: [fw_flow2supera, fw_pandora],
                fw_flow2supera: [fw_mlreco_inference],
                fw_mlreco_inference: [fw_mlreco_analysis],
                fw_mlreco_analysis: [fw_cafmaker],
                fw_pandora: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
