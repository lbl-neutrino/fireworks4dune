#!/usr/bin/env python3

import argparse
import json

from fireworks import Workflow, LaunchPad

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--name', default='Reflow_2x2')
    ap.add_argument('-i', '--inputs-json', required=True,
                    help='JSON file from ndlar_reflow/gen_input_list.py')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()

    fwm1 = FwMaker(args.name, 'ndlar_reflow', args.name)
    fwm2 = FwMaker(args.name, '2x2_sim', args.name)

    with open(args.inputs_json) as f:
        envs: list[dict[str, str]] = json.load(f)

    for env in envs:
        fw_flow = fwm1.make(env, 'Flow', 'flow')
        fw_flow2supera = fwm2.make(env, 'Flow2Supera', 'flow2supera')
        fw_spine = fwm2.make(env, 'SPINE', 'spine')
        fw_flow2root = fwm2.make(env, 'Flow2root', 'flow2root')
        fw_pandora = fwm2.make(env, 'Pandora', 'pandora')
        fw_cafmaker = fwm2.make(env, 'CAFmaker', 'caf')

        fireworks = [fw_flow,
                     fw_flow2supera, fw_spine,
                     fw_flow2root, fw_pandora,
                     fw_cafmaker]

        deps = {fw_flow: [fw_flow2supera, fw_flow2root],
                fw_flow2supera: [fw_spine],
                fw_flow2root: [fw_pandora],
                fw_spine: [fw_cafmaker],
                fw_pandora: [fw_cafmaker]}

        wf = Workflow(fireworks, deps, name=args.name)
        lpad.add_wf(wf)


if __name__ == '__main__':
    main()
