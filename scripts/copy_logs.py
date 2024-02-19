#!/usr/bin/env python3

import argparse
from functools import lru_cache
from pathlib import Path
import shutil

import pymongo
import fireworks


DEFAULT_LOGBASE = '/pscratch/sd/d/dunepr/logs/MiniRun4.5'
DEFAULT_PRODNAME = 'MiniRun4.5_1E19_RHC'

STEP2CODEDIR = {
    'caf': 'run-cafmaker',
    'flow': 'run-ndlar-flow',
    'flow2supera': 'run-mlreco',
    'mlreco_analysis': 'run-mlreco',
    'mlreco_inference': 'run-mlreco',
    'larnd': 'run-larnd-sim'
}

DELIMITERS = {
    'flow2supera': 'RUNNING install/flow2supera/bin/run_flow2supera.py',
    # TODO
}


def get_logpath(logbase: Path, prodname: str, step: str, idx: int) -> Path:
    subdir = idx // 1000 * 1000
    path = (logbase / STEP2CODEDIR[step] / f'{prodname}.{step}' / 'LOGS'
            / f'{subdir:07d}' / f'{prodname}.{step}.{idx:07d}.log')
    assert path.exists()
    return path


def get_outdir(outbase: Path, prodname: str, step: str) -> Path:
    return outbase / f'{prodname}.{step}'


@lru_cache
def get_fws() -> pymongo.collection.Collection:
    lpad = fireworks.LaunchPad.auto_load()
    db = lpad.connection[lpad.name]
    return db['fireworks']


def get_idxs(prodname: str, step: str, state: str) -> list[int]:
    name = f'{prodname}.{step}'
    return [int(d['spec']['env']['ARCUBE_INDEX'])
            for d in get_fws().find({'name': name, 'state': state})]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--logbase', type=Path, default=Path(DEFAULT_LOGBASE))
    ap.add_argument('--prodname', default=DEFAULT_PRODNAME)
    ap.add_argument('--outbase', type=Path, required=True)
    ap.add_argument('--state', default='FIZZLED')
    ap.add_argument('--dry-run', action='store_true')
    args = ap.parse_args()

    for step in STEP2CODEDIR.keys():
        idxs = get_idxs(args.prodname, step, args.state)
        if not idxs:
            continue

        outdir = get_outdir(args.outbase, args.prodname, step)
        outdir.mkdir(parents=True, exist_ok=True)

        for idx in idxs:
            logpath = get_logpath(args.logbase, args.prodname, step, idx)
            print(f'COPY {logpath} TO {outdir}')
            if not args.dry_run:
                shutil.copy(logpath, outdir)


if __name__ == '__main__':
    main()
