#!/usr/bin/env python3

import argparse
import json

from fireworks import Workflow, LaunchPad

from fw4dune_tasks import FwMaker


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-n', '--name', required=True, help='e.g. Reflow_2x2_v12')
    ap.add_argument('-i', '--inputs-json', required=True,
                    help='JSON file from ndlar_reflow/gen_input_list.py')
    ap.add_argument('--charge-only', action='store_true')
    ap.add_argument('--light-only', action='store_true')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()

    fwm = FwMaker(args.name, 'ND_Production', args.name)

    with open(args.inputs_json) as f:
        envs: list[dict[str, str]] = json.load(f)

    for env in envs:
        if 'ND_PRODUCTION_CHARGE_FILE' in env:                    # charge basis
            if args.charge_only:
                env.pop('ND_PRODUCTION_LIGHT_FILES', None)
            fw_flow = fwm.make(env, 'Flow_Charge_Centric', 'flow')
        elif 'ND_PRODUCTION_LIGHT_FILE' in env:                   # light basis
            if args.light_only:
                env.pop('ND_PRODUCTION_CHARGE_FILES', None)
            fw_flow = fwm.make(env, 'Flow_Light_Centric', 'flow')
        else:
            raise ValueError('invalid json')

        fw_flow2supera = fwm.make(env, 'Flow2Supera', 'flow2supera')
        fw_spine = fwm.make(env, 'SPINE', 'spine')
        fw_flow2root = fwm.make(env, 'Flow2root', 'flow2root')
        fw_pandora = fwm.make(env, 'Pandora', 'pandora')
        fw_cafmaker = fwm.make(env, 'CAFmaker', 'caf')

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
