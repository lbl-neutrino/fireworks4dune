#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='NuE_CC_2603')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--repo', default='NDComplex_v1')
    ap.add_argument('--size', type=int, default=1, help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=0, help='Starting index of output files')
    args = ap.parse_args()

    if args.name is None:
        args.name = args.base_env_prefix

    lpad = LaunchPad.auto_load()

    fwm = FwMaker(args.base_env_prefix, args.repo, args.name)

    for i in range(args.start, args.start + args.size):
        for mode in ['noFar_noShield', 'noFar_withShield',
                     'withFar_noShield', 'withFar_withShield']:
            fw_flow2supera = fwm.make_mc(i, 'Flow2Supera', f'flow2supera.{mode}', category='flow2supera')
            fw_spine = fwm.make_mc(i, 'MLreco_Spine_SpineProd', f'spine.{mode}', category='spine_cpu')

            fireworks = [fw_flow2supera, fw_spine]

            arrows = {fw_flow2supera: [fw_spine]}

            wf = Workflow(fireworks, arrows, name=f'{args.name}.spine_wf.{mode})

            lpad.add_wf(wf)


if __name__ == '__main__':
    main()
