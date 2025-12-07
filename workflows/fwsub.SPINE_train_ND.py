#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='SPINE_train_ND_2512')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='SimForNDLAr_v4')
    ap.add_argument('--size', type=int, default=1000,
                    help='Number of workflows to add')
    ap.add_argument('--start', type=int, default=0,
                    help='Starting index of workflows')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env_prefix

    lpad = LaunchPad.auto_load()

    fwm = FwMaker(args.base_env_prefix, args.repo, args.name)

    for i in range(args.start, args.start + args.size):
        fw_edep = fwm.make_mc(i, 'Edep', 'edep', category='cpu')
        fw_convert2h5 = fwm.make_mc(i, 'Convert2H5', 'convert2h5',
                                    category='cpu')
        fw_larnd = fwm.make_mc(i, 'LArND', 'larnd', category='gpu_long')
        fw_flow = fwm.make_mc(i, 'Flow', 'flow', category='cpu_long')
        fw_flow2supera = fwm.make_mc(i, 'Flow2Supera', 'flow2supera',
                                     category='cpu_long')

        fireworks = [fw_edep, fw_convert2h5, fw_larnd, fw_flow, fw_flow2supera]

        arrows = {fw_edep: [fw_convert2h5],
                  fw_convert2h5: [fw_larnd],
                  fw_larnd: [fw_flow],
                  fw_flow: [fw_flow2supera]}

        wf = Workflow(fireworks, arrows, name=args.name)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
