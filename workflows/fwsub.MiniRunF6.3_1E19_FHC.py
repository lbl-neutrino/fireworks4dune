#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker

HADD_FACTOR = 10


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base-env-prefix', default='MiniRunF6.3_1E19_FHC')
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
        pre_hadd_range = range(i*HADD_FACTOR, (i+1)*HADD_FACTOR)

        fws_genie_nu = [fwm.make(j, 'Genie', 'genie.nu', category='cpu_seconds')
                        for j in pre_hadd_range]
        fws_genie_rock = [fwm.make(j, 'Genie', 'genie.rock', category='cpu_hours')
                          for j in pre_hadd_range]
        fws_edep_nu = [fwm.make(j, 'Edep', 'edep.nu', category='cpu_seconds')
                       for j in pre_hadd_range]
        fws_edep_rock = [fwm.make(j, 'Edep', 'edep.rock', category='cpu_hours')
                         for j in pre_hadd_range]
        fw_hadd_nu = fwm.make(i, 'Hadd', 'edep.nu.hadd', category='cpu_seconds')
        fw_hadd_rock = fwm.make(i, 'Hadd', 'edep.rock.hadd', category='cpu_seconds')
        fw_spill = fwm.make(i, 'SpillBuild', 'spill', category='cpu_seconds')
        fw_edep2flat = fwm.make(i, 'Edep2Flat', 'edep2flat', category='cpu_minutes')
        fw_minerva = fwm.make(i, 'Minerva', 'minerva', category='cpu_minutes')
        fw_convert2h5 = fwm.make(i, 'Convert2H5', 'convert2h5', category='cpu_seconds')
        fw_larnd = fwm.make(i, 'LArND', 'larnd', category='gpu_minutes')
        fw_flow = fwm.make(i, 'Flow', 'flow', category='cpu_minutes')
        fw_plots = fwm.make(i, 'Plots', 'plots', category='cpu_minutes')

        fw_flow2supera = fwm.make(i, 'Flow2Supera', 'flow2supera', category='cpu_minutes')
        fw_spine = fwm.make(i, 'Spine', 'spine', category='gpu_minutes')
        fw_flow2root = fwm.make(i, 'Flow2root', 'flow2root', category='gpu_minutes')
        fw_pandora = fwm.make(i, 'Pandora', 'pandora', category='cpu_minutes')
        fw_cafmaker = fwm.make(i, 'CAFmaker','caf', category='cpu_minutes')

        fireworks = [*fws_genie_nu, *fws_genie_rock,
                     *fws_edep_nu, *fws_edep_rock,
                     fw_hadd_nu, fw_hadd_rock, fw_spill,
                     fw_edep2flat, fw_minerva,
                     fw_convert2h5, fw_larnd, fw_flow, fw_plots,
                     fw_flow2supera, fw_spine,
                     fw_flow2root, fw_pandora,
                     fw_cafmaker]

        deps = {**{fw_genie_nu: [fw_edep_nu] for fw_genie_nu, fw_edep_nu
                   in zip(fws_genie_nu, fws_edep_nu)},
                **{fw_genie_rock: [fw_edep_rock] for fw_genie_rock, fw_edep_rock
                   in zip(fws_genie_rock, fws_edep_rock)},
                **{fw_edep_nu: [fw_hadd_nu] for fw_edep_nu in fws_edep_nu},
                **{fw_edep_rock: [fw_hadd_rock] for fw_edep_rock in fws_edep_rock},
                fw_hadd_nu: [fw_spill],
                fw_hadd_rock: [fw_spill],
                fw_spill: [fw_edep2flat, fw_convert2h5],
                fw_edep2flat: [fw_minerva],
                fw_minerva: [fw_cafmaker],
                fw_convert2h5: [fw_larnd],
                fw_larnd: [fw_flow],
                fw_flow: [fw_flow2supera, fw_flow2root, fw_plots],
                fw_flow2supera: [fw_spine],
                fw_flow2root: [fw_pandora],
                fw_spine: [fw_cafmaker],
                fw_pandora: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)

        lpad.add_wf(wf)

if __name__ == '__main__':
    main()
