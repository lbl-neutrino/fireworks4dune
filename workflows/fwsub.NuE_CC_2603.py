#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='NuE_CC_2603')
    ap.add_argument('--name', help='Defaults to --base-env-prefix')
    ap.add_argument('--size', type=int, default=1,
                    help='Number of final outputs (post-hadd etc.) to produce')
    ap.add_argument('--start', type=int, default=0,
                    help='Starting index of output files')
    ap.add_argument('--sim-mode', type=str, default='noFar_noShield')
    ap.add_argument('--run-genie', action='store_true')
    args = ap.parse_args()

    name = args.name if args.name else args.base_env_prefix
    sim_mode = args.sim_mode
    lpad = LaunchPad.auto_load()
    fwm = FwMaker(args.base_env_prefix, repo='NDComplex_v1', name=name)

    for i in range(args.start, args.start + args.size):
        fw_genie = fwm.make_mc(
            i, 'Genie', 'genie', category='cpu')
        fw_edep = fwm.make_mc(
            i, 'Edep', 'edep', category='cpu')
        fw_convert2h5 = fwm.make_mc(
            i, 'Convert2H5', 'convert2h5', category='cpu')
        fw_larnd = fwm.make_mc(
            i, 'LArND', f'larnd.{sim_mode}', category='larnd')
        fw_flow = fwm.make_mc(
            i, 'Flow', f'flow.{sim_mode}', category='flow')
        fw_flow2supera = fwm.make_mc(
            i, 'Flow2Supera', f'flow2supera.{sim_mode}', category='f2s')
        fw_spine = fwm.make_mc(
            i, 'MLreco_Spine_SpineProd', f'spine.{sim_mode}', category='spine')

        fireworks = []
        arrows = {}

        if args.run_genie:
            fireworks.extend([fw_genie, fw_edep, fw_convert2h5])
            arrows.update({fw_genie: [fw_edep],
                           fw_edep: [fw_convert2h5],
                           fw_convert2h5: [fw_larnd]})

        fireworks.extend([fw_larnd, fw_flow, fw_flow2supera, fw_spine])
        arrows.update({fw_larnd: [fw_flow],
                       fw_flow: [fw_flow2supera],
                       fw_flow2supera: [fw_spine]})

        wf = Workflow(fireworks, arrows, name=name)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
