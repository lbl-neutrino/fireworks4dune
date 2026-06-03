#!/usr/bin/env bash

source admin/load_fireworks.sh
set +o posix

name=2x2_CosmicRun1
logdir=/pscratch/sd/d/danxing/cosmic_prod/logs/$name
export FW4DUNE_SLEEP_SEC=30

scripts/load_yaml.py --replace specs/SimFor2x2_v7.yaml specs/$name/*.yaml

mkdir -p "$logdir"

workflows/fwsub.2x2_CosmicRun1.py --base-env-prefix $name --size 10

# CORSIKA, edep-sim, convert2h5 (CPU)
CPU_SEC_JOBID=$(sbatch --parsable -o "$logdir"/slurm-%j.txt \
    --ntasks-per-node=64 --array=1-1 -N 1 -t 120 \
    slurm/fw_cpu.slurm.sh cpu_seconds rapidfire)
echo "Submitted cpu_seconds job: $CPU_SEC_JOBID"

# larnd-sim (GPU) - wait for cpu_seconds to COMPLETE
LARND_JOBID=$(sbatch --parsable -o "$logdir"/slurm-%j.txt \
    --array=1-3 -N 1 -t 120 -C "gpu" \
    --dependency=afterany:$CPU_SEC_JOBID \
    slurm/fw_gpu.slurm.sh gpu_minutes singleshot)
echo "Submitted larnd gpu job: $LARND_JOBID"

# flow, flow2supera (CPU) - wait for larnd to COMPLETE
CPU_MIN_JOBID=$(sbatch --parsable -o "$logdir"/slurm-%j.txt \
    --ntasks-per-node=16 --array=1-1 -N 1 -t 120 \
    --dependency=afterany:$LARND_JOBID \
    slurm/fw_cpu.slurm.sh cpu_minutes rapidfire)
echo "Submitted cpu_minutes job: $CPU_MIN_JOBID"

# spine (GPU) - wait for flow/flow2supera to COMPLETE
SPINE_JOBID=$(sbatch --parsable -o "$logdir"/slurm-%j.txt \
    --array=1-3 -N 1 -t 90 -C "gpu" \
    --dependency=afterany:$CPU_MIN_JOBID \
    slurm/fw_gpu.slurm.sh gpu_minutes singleshot)
echo "Submitted spine gpu job: $SPINE_JOBID"