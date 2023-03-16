#!/usr/bin/env bash
#SBATCH --account=dune
#SBATCH --qos=regular
#SBATCH --constraint=cpu
#SBATCH --time=2:00:00
#SBATCH --ntasks-per-node=256

# The "auto" means that we generate the fworker file automatically!
# Eventually this should replace edep_sim_job_fw.sh

name=$1; shift
if [[ -z "$name" ]]; then
    echo "Required argument 'name' not given. Better luck next time."
    exit 1
fi

fw_launchdir=$SCRATCH/fw_launches
mkdir -p "$fw_launchdir"
cd "$fw_launchdir"

logdir=$SCRATCH/logs.edep_sim_job_fw/$SLURM_JOBID
mkdir -p $logdir

fworker=$logdir/fworker.yaml
cat > "$fworker" <<EOF
name: '$name'
category: '$name'
query: '{}'
EOF

# srun rlaunch -w $fw_confdir/fworker_edep_sim.yaml rapidfire
srun -o "$logdir"/output-%j.%t.txt rlaunch -w "$fworker" singleshot
