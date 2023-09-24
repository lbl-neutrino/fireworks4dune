#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=MiniRun4_1E19_RHC
start=0
single_size=10240
spill_size=1024
logdir=$SCRATCH/logs.$name
export FW4DUNE_SLEEP_SEC=60

scripts/load_yaml.py --replace specs/SimFor2x2_v3.yaml specs/$name/*.yaml

mkdir -p "$logdir"

scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env "$name".nu --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env "$name".rock --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env "$name".nu.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env "$name".rock.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_SpillBuild --base-env "$name".spill --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env "$name".convert2h5 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_LArND --base-env "$name".larnd --name "$name".larnd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env "$name".flow --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Plots --base-env "$name".plots --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Plots --base-env "$name".plots --size 1 --start 0

lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh "$name".nu rapidfire
# 45-150 minutes each:
sbatch -o "$logdir"/slurm-%j.txt --array=1-10 -N 4 -t 180 slurm/fw_cpu.slurm.sh "$name".rock singleshot
# bad: 22878

sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh "$name".nu.hadd rapidfire
sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh "$name".rock.hadd rapidfire

# took an hour
sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 90 slurm/fw_cpu.slurm.sh "$name".spill rapidfire

# took 15 minutes
sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh "$name".convert2h5 rapidfire

sbatch -o "$logdir"/slurm-%j.txt --array=1-12 -N 4 slurm/fw_gpu.slurm.sh "$name".larnd rapidfire

sbatch -o "$logdir"/slurm-%j.txt --ntasks-per-node=128 --array=1-8 -N 1 -t 120 --no-kill slurm/fw_cpu.slurm.sh "$name".flow rapidfire

sbatch -t 180 -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 slurm/fw_cpu.slurm.sh "$name".plots rapidfire
sbatch -t 60 -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 --ntasks-per-node=128 slurm/fw_cpu.slurm.sh "$name".plots rapidfire
