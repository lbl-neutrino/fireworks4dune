#!/usr/bin/env python3

import argparse

from fireworks import LaunchPad, Workflow

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prefix', default='MiniProdN5p1_NDComplex_FHC')
    ap.add_argument('--postfix', default='full.sanddrift')
    ap.add_argument('--size', type=int, default=100,
                    help='Number of workflows to add')
    ap.add_argument('--start', type=int, default=0,
                    help='Starting index of workflows')
    args = ap.parse_args()

    prefix, postfix = args.prefix, args.postfix
    lpad = LaunchPad.auto_load()
    fwm = FwMaker(base_env_prefix=prefix, repo='NDComplex_v1', name=prefix)

    for i in range(args.start, args.start + args.size):
        fw_spine = fwm.make_mc(index=i,
                               runner_postfix='MLreco_Spine_SpineProd',
                               step_postfix=f'spine2.{postfix}',
                               category='spine')

        fireworks = [fw_spine]
        arrows = {}

        wf = Workflow(fireworks, arrows, name=prefix)

        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
