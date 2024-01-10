#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix                    # sneaky sneaky, NERSC

name=MegaRun5_1E20_RHC
logdir=$SCRATCH/slurm_logs/$name
export FW4DUNE_SLEEP_SEC=10

load_yaml.py --replace specs/SimFor2x2_v4.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.MegaRun5_1E20_RHC.py

lpad admin tuneup --full

sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 180 slurm/fw_cpu.slurm.sh mega_cpu_hours rapidfire --timeout $((60 * 140))
sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 30 slurm/fw_cpu.slurm.sh mega_cpu_seconds rapidfire

sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 4 -t 240 slurm/fw_gpu.slurm.sh -C "gpu&hbm80g" mega_gpu_minutes rapidfire

sbatch -o "$logdir"/slurm-%j.txt --array=1-2 -N 4 -t 30 slurm/fw_cpu.slurm.sh mega_cpu_minutes rapidfire

# Run the plots outside the Workflow
scripts/fwsub.py --runner SimFor2x2_v4_Plots --base-env "$name.plots" --worker mega_plots --size 10000 --start 0
