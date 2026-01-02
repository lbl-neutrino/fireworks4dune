#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--config', required=True,
                    help='Name of the mpvmpr config (e.g. proton_plus_muon)')
    ap.add_argument('--prefix', default='Shield_Plane_2601')
    ap.add_argument('--size', type=int, default=100,
                    help='Number of workflows to add')
    ap.add_argument('--start', type=int, default=0,
                    help='Starting index of workflows')
    ap.add_argument('--sim-mode', type=str, default='noFar_noShield')
    ap.add_argument('--run-edep', action='store_true')
    ap.add_argument('--run-spine', action='store_true')
    args = ap.parse_args()

    name = f'{args.prefix}.{args.config}'
    sim_mode = args.sim_mode
    lpad = LaunchPad.auto_load()
    fwm = FwMaker(base_env_prefix=name, repo='SPINETrainForNDLAr_v1', name=name)

    for i in range(args.start, args.start + args.size):
        fw_edep = fwm.make_mc(
            i, 'Edep', 'edep', category='edep')
        fw_convert2h5 = fwm.make_mc(
            i, 'Convert2H5', 'convert2h5', category='convert2h5')
        fw_larnd = fwm.make_mc(
            i, 'LArND', f'larnd.{sim_mode}', category='larnd')
        fw_flow = fwm.make_mc(
            i, 'Flow', f'flow.{sim_mode}', category='flow')
        fw_flow2supera = fwm.make_mc(
            i, 'Flow2Supera', f'flow2supera.{sim_mode}', category='f2s')
        fw_spine = fwm.make_mc(
            i, 'SPINE', f'spine.{sim_mode}', category='spine')

        fireworks = []
        arrows = {}

        if args.run_edep:
            fireworks.extend([fw_edep, fw_convert2h5])
            arrows.update({fw_edep: [fw_convert2h5],
                           fw_convert2h5: [fw_larnd]})

        fireworks.extend([fw_larnd, fw_flow])
        arrows.update({fw_larnd: [fw_flow]})

        if args.run_spine:
            fireworks.extend([fw_flow2supera, fw_spine])
            arrows.update({fw_flow: [fw_flow2supera],
                           fw_flow2supera: [fw_spine]})

        wf = Workflow(fireworks, arrows, name=name)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
