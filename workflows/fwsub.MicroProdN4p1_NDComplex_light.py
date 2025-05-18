#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MicroProdN4p1_NDComplex_FHC')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='NDComplex_v1')
    ap.add_argument('--size', type=int, default=102, help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=2459, help='Starting index of output files')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env_prefix

    lpad = LaunchPad.auto_load()

    fwm = FwMaker(args.base_env_prefix, args.repo, args.name)

    for i in range(args.start, args.start + args.size):
        fw_larnd = fwm.make_mc(i, 'LArND', 'larnd.full.light', category='gpu_slow')
        fw_flow = fwm.make_mc(i, 'Flow', 'flow.full.light', category='cpu_highmem')
        fw_flow2root = fwm.make_mc(i, 'Flow2root.full.light', 'flow2root', category='cpu_highmem')
        fw_pandora = fwm.make_mc(i, 'Pandora', 'pandora.full.light', category='cpu_slow')
        fw_flow2supera = fwm.make_mc(i, 'Flow2Supera', 'flow2supera.full.light', category='cpu_slow')
        fw_spine = fwm.make_mc(i, 'Spine', 'spine.full.light', category='gpu_fast')
        fw_cafmaker = fwm.make_mc(i, 'CAFmaker','caf.full.light', category='cpu_highmem')

        fireworks = [fw_larnd, fw_flow, fw_flow2root, fw_pandora,
                     fw_flow2supera, fw_spine, fw_cafmaker]

        deps = {fw_larnd: [fw_flow],
                fw_flow: [fw_flow2supera, fw_flow2root],
                fw_flow2supera: [fw_spine],
                fw_flow2root: [fw_pandora],
                fw_pandora: [fw_cafmaker],
                fw_spine: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)

if __name__ == '__main__':
    main()
