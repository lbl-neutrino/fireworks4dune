#!/usr/bin/env python3

import datetime
import os
from pathlib import Path
import pickle
import shutil
import time

import fireworks
from pymongo.collection import Collection


DEFAULT_PROD_NAME = 'MegaRun5_1E20_RHC'

DEFAULT_SRC_ROOT = '/pscratch/sd/m/mkramer/output/MegaRun5'
DEFAULT_DEST_ROOT = '/global/cfs/cdirs/dune/www/data/2x2/simulation/productions/MegaRun5_1E20_RHC'

# When these steps are all completed (for a given ND_PRODUCTION_INDEX), rescue any
# desired files corresponding to the same ND_PRODUCTION_INDEX:
TERMINAL_STEPS = ['convert2h5', 'minerva']
# These are the steps from which we want to rescue files:
RESCUE_STEPS = ['genie.rock', 'edep.nu.hadd', 'edep.rock.hadd']
# And these are the ones we just want to delete:
DELETE_STEPS = ['edep.nu', 'edep.rock', 'spill']
# These steps run before hadd, so ND_PRODUCTION_INDEX must be scaled appropriately:
PRE_HADD_STEPS = ['genie.rock', 'genie.nu', 'edep.rock', 'edep.nu']

# Map from names of steps to the corresponding subdirectory of the root
# (mirrors the 2x2_sim source code structure):
SUBDIR_MAP = {
    'genie.nu': 'run-genie',
    'genie.rock': 'run-genie',
    'edep.nu': 'run-edep-sim',
    'edep.rock': 'run-edep-sim',
    'edep.nu.hadd': 'run-hadd',
    'edep.rock.hadd': 'run-hadd',
    'spill': 'run-spill-build',
    'convert2h5': 'run-convert2h5',
    'minerva': 'run-minerva',
}

OUTPUTS_PER_DIR = 1000
HADD_FACTOR = 10
MIN_MTIME_MINUTES = 30
SLEEP_SECONDS = 60


class RescueFromScratch:
    def __init__(self,
                 prod_name=DEFAULT_PROD_NAME,
                 src_root=DEFAULT_SRC_ROOT,
                 dest_root=DEFAULT_DEST_ROOT,
                 pickled_done: str | None =None):
        self.prod_name = Path(prod_name)
        self.src_root = Path(src_root)
        self.dest_root = Path(dest_root)
        self.pickled_done = pickled_done

        lpad = fireworks.LaunchPad.auto_load()
        mongo = lpad.connection[lpad.name]
        self.fwks: Collection = mongo['fireworks']

        if self.pickled_done and Path(self.pickled_done).exists():
            self.done = pickle.load(open(self.pickled_done, 'rb'))
        else:
            self.done = set()

    @staticmethod
    def pad_file_num(file_num: int) -> str:
        return f'{file_num:07d}'

    @staticmethod
    def idx(fwk: dict) -> int:
        return int(fwk['spec']['env']['ND_PRODUCTION_INDEX'])

    @staticmethod
    def has_cooled_down(fwk: dict) -> bool:
        """
        Returns `true` if the firework `fwk` was updated more than
        `MIN_MTIME_MINUTES` ago.
        """
        updated = datetime.datetime.fromisoformat(fwk['updated_on'])
        dt = datetime.datetime.utcnow() - updated
        return dt.total_seconds() > 60 * MIN_MTIME_MINUTES

    def skip(self, fwk: dict) -> bool:
        return self.idx(fwk) in self.done

    def completed(self, step: str) -> set[int]:
        """
        Get the `ND_PRODUCTION_INDEX` values for which `step` has completed.
        """
        query = {'name': f'{self.prod_name}.{step}',
                 'state': 'COMPLETED'}
        cursor = self.fwks.find(query, ['spec.env.ND_PRODUCTION_INDEX', 'updated_on'])
        return {self.idx(fwk) for fwk in cursor
                if (not self.skip(fwk)) and self.has_cooled_down(fwk)}

    def rescuable(self) -> set[int]:
        """
        Get the `ND_PRODUCTION_INDEX` values for which all `TERMINAL_STEPS` have
        completed.
        """
        sets = (self.completed(step) for step in TERMINAL_STEPS)
        return set.intersection(*sets)

    def rescue_single(self, terminal_num: int):
        """
        Go through files where `ND_PRODUCTION_INDEX == terminal_num` and move them
        off SCRATCH if they aren't currently needed (i.e. if the corresponding
        `TERMINAL_STEPS` have completed)
        """
        for step in RESCUE_STEPS + DELETE_STEPS:
            if step in PRE_HADD_STEPS:
                rescue_nums = range(HADD_FACTOR*terminal_num,
                                    HADD_FACTOR*(terminal_num+1))
            else:
                rescue_nums = [terminal_num]

            range_start = rescue_nums[0] // OUTPUTS_PER_DIR * OUTPUTS_PER_DIR
            # e.g. "0023000" for num=23456:
            range_name = self.pad_file_num(range_start)

            in_dir = (self.src_root / SUBDIR_MAP[step]
                      / f'{self.prod_name}.{step}')

            for type_dir in in_dir.iterdir(): # e.g. GHEP, GTRAC
                sub_dir = in_dir / type_dir / range_name
                for rescue_num in rescue_nums:
                    padded_num = self.pad_file_num(rescue_num)
                    for src_file in sub_dir.glob(f'*.{padded_num}.*'):
                        # Special case: Delete GTRAC even if we're rescuing GHEP
                        is_gtrac = '.GTRAC.' in src_file.name
                        if step in DELETE_STEPS or is_gtrac:
                            print(f'{src_file}\n')
                            os.unlink(src_file)
                        else:
                            dest_file = (self.dest_root
                                         / src_file.relative_to(self.src_root))
                            print(f'{src_file}\n{dest_file}\n')
                            dest_file.parent.mkdir(parents=True, exist_ok=True)
                            shutil.move(src_file, dest_file)

    def rescue_batch(self):
        """
        Call `rescue_singles` on every eligible `ND_PRODUCTION_INDEX`.
        """
        def save():
            if self.pickled_done:
                pickle.dump(self.done, open(self.pickled_done, 'wb'))

        try:
            for terminal_num in self.rescuable():
                print(f'{terminal_num}\n')
                self.rescue_single(terminal_num)
                self.done.add(terminal_num)
        except KeyboardInterrupt:
            save()
            raise

        save()


    def loop(self):
        while True:
            self.rescue_batch()
            time.sleep(SLEEP_SECONDS)


def main():
    rfs = RescueFromScratch(pickled_done='rescued.pkl')
    rfs.loop()


if __name__ == '__main__':
    main()
