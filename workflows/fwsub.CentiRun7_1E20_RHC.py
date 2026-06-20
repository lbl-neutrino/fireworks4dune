#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker

NAME = 'CentiRun7_1E20_RHC'
REPO = 'SimFor2x2_v7'
HADD_FACTOR = 10


def make_upstream_workflow(tag: str, i: int, fwm: FwMaker):
    pre_hadd_range = range(i*HADD_FACTOR, (i+1)*HADD_FACTOR)

    fws_genie = [fwm.make_mc(j, 'Genie', f'genie.{tag}', category=f'genie_{tag}')
                 for j in pre_hadd_range]

    fws_edep = [fwm.make_mc(j, 'Edep', f'edep.{tag}', category=f'edep_{tag}')
                for j in pre_hadd_range]

    fw_hadd = fwm.make_mc(i, 'Hadd', f'edep.{tag}.hadd', category='hadd')

    fireworks = [*fws_genie, *fws_edep, fw_hadd]

    arrows = {**{fw_genie: [fw_edep] for fw_genie, fw_edep
                 in zip(fws_genie, fws_edep)},
              **{fw_edep: [fw_hadd] for fw_edep in fws_edep}}

    return Workflow(fireworks, arrows, name=f'WORKFLOW.{NAME}.{tag}')


def make_downstream_workflow(i: int, fwm: FwMaker):
    fw_spill = fwm.make_mc(i, 'SpillBuild', 'spill', category='cpu')
    fw_edep2flat = fwm.make_mc(i, 'Edep2Flat', 'edep2flat', category='cpu_highmem')
    fw_minerva = fwm.make_mc(i, 'Minerva', 'minerva', category='cpu')
    fw_convert2h5 = fwm.make_mc(i, 'Convert2H5', 'convert2h5', category='cpu')
    fw_larnd = fwm.make_mc(i, 'LArND', 'larnd', category='gpu_long')
    fw_flow = fwm.make_mc(i, 'Flow', 'flow', category='cpu_highmem')
    fw_flow2supera = fwm.make_mc(i, 'Flow2Supera', 'flow2supera', category='cpu')
    fw_spine = fwm.make_mc(i, 'Spine', 'spine', category='gpu')
    fw_flow2root = fwm.make_mc(i, 'Flow2root', 'flow2root', category='cpu_highmem')
    fw_pandora = fwm.make_mc(i, 'Pandora', 'pandora', category='cpu')
    fw_cafmaker = fwm.make_mc(i, 'CAFmaker','caf', category='cpu')

    fireworks = [fw_spill,
                 fw_edep2flat, fw_minerva,
                 fw_convert2h5, fw_larnd, fw_flow,
                 fw_flow2supera, fw_spine,
                 fw_flow2root, fw_pandora,
                 fw_cafmaker]

    arrows = {fw_spill: [fw_convert2h5, fw_edep2flat],
              fw_convert2h5: [fw_larnd],
              fw_edep2flat: [fw_minerva],
              fw_minerva: [fw_cafmaker],
              fw_larnd: [fw_flow],
              fw_flow: [fw_flow2supera, fw_flow2root],
              fw_flow2supera: [fw_spine],
              fw_flow2root: [fw_pandora],
              fw_spine: [fw_cafmaker],
              fw_pandora: [fw_cafmaker]}

    return Workflow(fireworks, arrows, name=f'WORKFLOW.{NAME}.spill')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--size', type=int, required=True,
                    help='Number of (post-hadd) outputs to produce')
    ap.add_argument('--start', type=int, default=0,
                    help='Starting index of output files')
    ap.add_argument('--nu', action='store_true')
    ap.add_argument('--rock', action='store_true')
    ap.add_argument('--spill', action='store_true')
    args = ap.parse_args()

    if sum([int(args.nu), int(args.rock), int(args.spill)]) != 1:
        raise RuntimeError('Please specify ONE of --nu, --rock, or --spill')

    lpad = LaunchPad.auto_load()
    fwm = FwMaker(name=NAME, base_env_prefix=NAME, repo=REPO)

    for i in range(args.start, args.start + args.size):
        if args.nu:
            wf = make_upstream_workflow('nu', i, fwm)
        elif args.rock:
            wf = make_upstream_workflow('rock', i, fwm)
        else:
            wf = make_downstream_workflow(i, fwm)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
