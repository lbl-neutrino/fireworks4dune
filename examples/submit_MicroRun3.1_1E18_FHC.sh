#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimFor2x2_v3.yaml specs/MicroRun3.1_1E18_FHC/*.yaml

start=0
single_size=10240
hadd_size=256
logdir=$SCRATCH/logs.MicroRun3.1_1E18_FHC

mkdir -p $logdir

scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MicroRun3.1_1E18_FHC.rock --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MicroRun3.1_1E18_FHC.nu --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MicroRun3.1_1E18_FHC.rock.hadd --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MicroRun3.1_1E18_FHC.nu.hadd --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_SpillBuild --base-env MicroRun3.1_1E18_FHC.spill --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env MicroRun3.1_1E18_FHC.convert2h5 --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_LArND --base-env MicroRun3.1_1E18_FHC.larnd --size $hadd_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MicroRun3.1_1E18_FHC.flow --size $hadd_size --start $start

lpad admin tuneup --full

# 40-60 minutes, one core on otherwise idle node:
# time scripts/run_rlaunch.sh MicroRun3.1_1E18_FHC.rock singleshot

FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-10 -N 4 -t 120 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.rock rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-5 -N 4 -t 120 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.nu rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-2 -N 1 -t 30 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.rock.hadd rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-2 -N 1 -t 30 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.nu.hadd rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 -t 120 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.spill rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.convert2h5 rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-10 -N 4 -t 120 slurm/fw_gpu.slurm.sh MicroRun3.1_1E18_FHC.larnd rapidfire
FW4DUNE_SLEEP_SEC=60 sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 -t 60 slurm/fw_cpu.slurm.sh MicroRun3.1_1E18_FHC.flow rapidfire
