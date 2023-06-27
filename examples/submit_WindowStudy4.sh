#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimFor2x2_v3.yaml specs/WindowStudy4/*.yaml

start=0
single_size=20480
hadd_size=256
logdir=$SCRATCH/logs.WindowStudy4_1E18_FHC

mkdir -p $logdir

scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env WindowStudy4_1E18_FHC.rock --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env WindowStudy4_1E18_FHC.rock.hadd --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env WindowStudy4_1E18_FHC.convert2h5 --size $hadd_size --start $start

lpad admin tuneup --full

# 40-60 minutes, one core on otherwise idle node:
# time scripts/run_rlaunch.sh WindowStudy4_1E18_FHC.rock singleshot

FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-20 -N 4 -t 180 slurm/fw_cpu.slurm.sh WindowStudy4_1E18_FHC.rock singleshot

# 2 minutes:
# time scripts/run_rlaunch.sh WindowStudy4_1E18_FHC.hadd singleshot

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 -t 30 slurm/fw_cpu.slurm.sh WindowStudy4_1E18_FHC.rock.hadd rapidfire

# 3 minutes:
# time scripts/run_rlaunch.sh WindowStudy4_1E18_FHC.convert2h5 singleshot

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 -t 30 slurm/fw_cpu.slurm.sh WindowStudy4_1E18_FHC.convert2h5 rapidfire
