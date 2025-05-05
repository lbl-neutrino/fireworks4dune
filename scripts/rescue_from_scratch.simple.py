#!/usr/bin/env python3

import argparse
from multiprocessing import Pool
from pathlib import Path
import random
import shutil
import time


def transfer(src: Path, dest: Path):
    print(f'MOVE {src} {dest}')

    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(src, dest)

    print(f'DONE {src} {dest}')

    dest_readonly = Path('/dvs_ro/cfs') \
        / dest.relative_to('/global/cfs')

    src.symlink_to(dest_readonly)



def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--srcdir', type=Path, required=True)
    ap.add_argument('--destdir', type=Path, required=True)
    ap.add_argument('--mmin', type=float, default=30,
                    help='minimum time since last change (minutes)')
    ap.add_argument('--extra-subdir')
    ap.add_argument('--nproc', type=int, default=3)
    args = ap.parse_args()

    pool = Pool(args.nproc)

    while True:
        try:
            transfers: list[tuple[Path, Path]] = []

            for src in args.srcdir.rglob('*'):
                if 'tmp' in str(src):
                    continue

                if src.is_symlink() or (not src.is_file()):
                    continue

                if time.time() - src.stat().st_mtime < args.mmin*60:
                    continue

                if args.extra_subdir:
                    dest = args.destdir / args.extra_subdir \
                        / src.relative_to(args.srcdir)
                else:
                    dest = args.destdir / src.relative_to(args.srcdir)

                transfers.append((src, dest))

            random.shuffle(transfers)
            pool.starmap(transfer, transfers)

        except:
            pass

        print()
        time.sleep(30)


if __name__ == '__main__':
    main()
