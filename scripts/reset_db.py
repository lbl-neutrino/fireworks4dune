#!/usr/bin/env python

import sys

from fireworks.core.launchpad import LaunchPad

COLLECTIONS = ['repos', 'runners', 'base_envs']


def main():
    if input("Really? ").lower() == 'really':
        lpad = LaunchPad.auto_load()

        lpad.reset(password=None, require_password=False,
                   max_reset_wo_password=sys.maxsize)

        db = lpad.connection[lpad.name]

        for col in COLLECTIONS:
            db[col].drop()


if __name__ == '__main__':
    main()
