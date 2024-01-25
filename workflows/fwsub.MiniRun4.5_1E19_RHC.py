#!/usr/bin/env python3

import argparse

from typing import Optional

from fireworks import Firework, LaunchPad, Workflow

from fw4dune_tasks import RepoRunner


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MiniRun4.5_1E19_RHC')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimFor2x2_v5')
    ap.add_argument('--size', type=int, default=1000, help='Number of final outputs (post-hadd etc.) to produce')
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
        fw_convert2h5 = make_fw(i, 'Convert2H5', 'convert2h5', category='mini45_cpu_minutes')
        fw_validate_convert2h5 = make_fw(i, 'Plots', 'plots.edepsim_dumptree',
                                         category='mini45_plots')
        fw_larnd = make_fw(i, 'LArND', 'larnd', category='mini45_gpu_minutes')
        fw_validate_larnd_truth = make_fw(i, 'Plots', 'plots.larndsim_edeptruth',
                                          category='mini45_plots')
        fw_validate_larnd_sim = make_fw(i, 'Plots', 'plots.larndsim',
                                        category='mini45_plots')
        fw_flow = make_fw(i, 'Flow', 'flow', category='mini45_cpu_minutes')
        fw_validate_flow = make_fw(i, 'Plots', 'plots.flow',
                                   category='mini45_plots')
        fw_flow2supera = make_fw(i, 'Flow2Supera', 'flow2supera', category='mini45_cpu_minutes')
        fw_mlreco_inference = make_fw(i, 'MLreco_Inference', 'mlreco_inference',
                                      category='mini45_gpu_minutes')
        fw_mlreco_analysis = make_fw(i, 'MLreco_Analysis', 'mlreco_analysis',
                                     category='mini45_cpu_minutes')
        fw_pandora = make_fw(i, 'Pandora', 'pandora', category='mini45_cpu_minutes')
        fw_cafmaker = make_fw(i, 'CAFmaker','caf', category='mini45_cpu_minutes')

        fireworks = [fw_convert2h5, fw_validate_convert2h5,
                     fw_larnd, fw_validate_larnd_truth, fw_validate_larnd_sim,
                     fw_flow, fw_validate_flow,
                     fw_flow2supera, fw_mlreco_inference, fw_mlreco_analysis,
                     fw_pandora, fw_cafmaker]

        deps = {fw_convert2h5: [fw_validate_convert2h5, fw_larnd],
                fw_larnd: [fw_validate_larnd_truth, fw_validate_larnd_sim,
                           fw_flow],
                fw_flow: [fw_validate_flow, fw_flow2supera, fw_pandora],
                fw_flow2supera: [fw_mlreco_inference],
                fw_mlreco_inference: [fw_mlreco_analysis],
                fw_mlreco_analysis: [fw_cafmaker],
                fw_pandora: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
