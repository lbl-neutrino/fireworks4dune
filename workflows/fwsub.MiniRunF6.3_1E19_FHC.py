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

        fws_genie_nu = [fwm.make_mc(j, 'Genie', 'genie.nu', category='cpu')
                        for j in pre_hadd_range]
        fws_genie_rock = [fwm.make_mc(j, 'Genie', 'genie.rock', category='cpu_long')
                          for j in pre_hadd_range]
        fws_edep_nu = [fwm.make_mc(j, 'Edep', 'edep.nu', category='cpu')
                       for j in pre_hadd_range]
        fws_edep_rock = [fwm.make_mc(j, 'Edep', 'edep.rock', category='cpu_long')
                         for j in pre_hadd_range]
        fw_hadd_nu = fwm.make_mc(i, 'Hadd', 'edep.nu.hadd', category='cpu')
        fw_hadd_rock = fwm.make_mc(i, 'Hadd', 'edep.rock.hadd', category='cpu')
        fw_spill = fwm.make_mc(i, 'SpillBuild', 'spill', category='cpu')
        fw_edep2flat = fwm.make_mc(i, 'Edep2Flat', 'edep2flat', category='cpu_highmem')
        fw_minerva = fwm.make_mc(i, 'Minerva', 'minerva', category='cpu')
        fw_convert2h5 = fwm.make_mc(i, 'Convert2H5', 'convert2h5', category='cpu')
        fw_larnd = fwm.make_mc(i, 'LArND', 'larnd', category='gpu_long')
        fw_flow = fwm.make_mc(i, 'Flow', 'flow', category='cpu_highmem')
        fw_plots = fwm.make_mc(i, 'Plots', 'plots', category='plots')
        fw_flow2supera = fwm.make_mc(i, 'Flow2Supera', 'flow2supera', category='cpu')
        fw_spine = fwm.make_mc(i, 'Spine', 'spine', category='gpu')
        fw_flow2root = fwm.make_mc(i, 'Flow2root', 'flow2root', category='cpu_highmem')
        fw_pandora = fwm.make_mc(i, 'Pandora', 'pandora', category='cpu')
        fw_cafmaker = fwm.make_mc(i, 'CAFmaker','caf', category='cpu')

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
                fw_spill: [fw_convert2h5, fw_edep2flat],
                fw_convert2h5: [fw_larnd],
                fw_edep2flat: [fw_minerva],
                fw_minerva: [fw_cafmaker],
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
