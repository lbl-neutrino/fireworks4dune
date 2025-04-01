#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MiniRun6.4_1E19_RHC')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimFor2x2_v6')
    ap.add_argument('--size', type=int, default=1000, help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env_prefix

    lpad = LaunchPad.auto_load()

    fwm = FwMaker(args.base_env_prefix, args.repo, args.name)

    for i in range(args.start, args.start + args.size):
        fw_larnd = fwm.make(i, 'LArND', 'larnd', category='gpu_slow')
        fw_flow = fwm.make(i, 'Flow', 'flow', category='cpu_highmem')
        fw_plots = fwm.make(i, 'Plots', 'plots', category='validation')
        fw_flow2root = fwm.make(i, 'Flow2root', 'flow2root', category='cpu_highmem')
        fw_pandora = fwm.make(i, 'Pandora', 'pandora', category='cpu_slow')
        fw_flow2supera = fwm.make(i, 'Flow2Supera', 'flow2supera', category='cpu_slow')
        fw_spine = fwm.make(i, 'Spine', 'spine', category='gpu_fast')
        fw_cafmaker = fwm.make(i, 'CAFmaker','caf', category='cpu_highmem')

        fireworks = [fw_larnd, fw_flow, fw_flow2root, fw_pandora, fw_plots,
                     fw_flow2supera, fw_spine, fw_cafmaker]

        deps = {fw_larnd: [fw_flow],
                fw_flow: [fw_flow2supera, fw_flow2root, fw_plots],
                fw_flow2supera: [fw_spine],
                fw_flow2root: [fw_pandora],
                fw_pandora: [fw_cafmaker],
                fw_spine: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)

if __name__ == '__main__':
    main()
