#!/usr/bin/env python3

import argparse
from pathlib import Path
import time


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--srcdir', type=Path, required=True)
    ap.add_argument('--destdir', type=Path, required=True)
    ap.add_argument('--mmin', type=float, default=30,
                    help='minimum time since last change (minutes)')
    ap.add_argument('--extra-subdir')
    args = ap.parse_args()

    while True:
        for src in args.srcdir.rglob('*'):
            if src.name.endswith('tmp'):
                continue

            print(f'CHECK {src}')

            if not src.is_file():
                continue

            if time.time() - src.stat().st_mtime < args.mmin*60:
                continue

            if args.extra_subdir:
                dest = args.destdir / args.extra_subdir \
                    / src.relative_to(args.srcdir)
            else:
                dest = args.destdir / src.relative_to(args.srcdir)

            print(f'MOVE {src} {dest}')

            dest.parent.mkdir(parents=True, exist_ok=True)
            src.rename(dest)

            dest.symlink_to(src)

        time.sleep(30)


if __name__ == '__main__':
    main()
