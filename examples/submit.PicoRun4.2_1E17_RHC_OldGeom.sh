#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=PicoRun4.2_1E17_RHC_OldGeom
start=0
single_size=100
spill_size=10
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

lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $single_size -t 20 slurm/fw_cpu.slurm.sh "$name".nu rapidfire
# 45-150 minutes each:
sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $single_size -t 180 slurm/fw_cpu.slurm.sh "$name".rock singleshot

sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $spill_size -t 10 slurm/fw_cpu.slurm.sh "$name".nu.hadd rapidfire
sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $spill_size -t 10 slurm/fw_cpu.slurm.sh "$name".rock.hadd rapidfire

# took 3 minutes?
sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $spill_size -t 90 slurm/fw_cpu.slurm.sh "$name".spill rapidfire

# took 15 minutes
sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $spill_size -t 30 slurm/fw_cpu.slurm.sh "$name".convert2h5 rapidfire

sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node 4 --gpus-per-task 1 --ntasks $spill_size slurm/fw_gpu.slurm.sh "$name".larnd rapidfire

sbatch -o "$logdir"/slurm-%j.txt -q shared --mem-per-cpu 4GB --ntasks-per-node $spill_size -t 20 --no-kill slurm/fw_cpu.slurm.sh "$name".flow rapidfire

sbatch -o "$logdir"/slurm-%j.txt -q shared --ntasks-per-node $spill_size -t 20 slurm/fw_cpu.slurm.sh "$name".plots rapidfire
