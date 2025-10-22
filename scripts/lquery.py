#!/usr/bin/env -S python3

import os
import json
import subprocess
import argparse

def fws_query(args):
    query = {}
    if args.state:
        query['state'] = args.state

    if args.name:
        query['name'] = args.name

    q_str = str(query).replace("\'", "\"")
    command = f"lpad {args.cmd} -q \'{q_str}\'"
    return command

parser = argparse.ArgumentParser(prog='lquery')
parser.add_argument('-v', '--verbose', action='store_true')
subparsers = parser.add_subparsers(dest='cmd', required=True)

parser_get_fws = subparsers.add_parser('get_fws')
parser_get_fws.add_argument('-s', '--state')
parser_get_fws.add_argument('-n', '--name')
parser_get_fws.add_argument('-c', '--count', action='store_true')
parser_get_fws.set_defaults(func=fws_query)

parser_rerun_fws = subparsers.add_parser('rerun_fws')
parser_rerun_fws.add_argument('-s', '--state')
parser_rerun_fws.add_argument('-n', '--name')
parser_rerun_fws.set_defaults(func=fws_query)

parser_pause_fws = subparsers.add_parser('pause_fws')
parser_pause_fws.add_argument('-s', '--state')
parser_pause_fws.add_argument('-n', '--name')
parser_pause_fws.set_defaults(func=fws_query)

parser_prior_fws = subparsers.add_parser('set_priority')
parser_prior_fws.add_argument('-s', '--state')
parser_prior_fws.add_argument('-n', '--name')
parser_prior_fws.set_defaults(func=fws_query)

args = parser.parse_args()
# print(args)

if args.verbose:
    print("Running:", args.func(args))

# os.system(args.func(args))
ret = subprocess.run(args.func(args), shell=True, capture_output=True, text=True)
print(ret.stdout)

#if args.count:
#    js = json.loads(ret.stdout)
#    print("Count: ", len(js))
