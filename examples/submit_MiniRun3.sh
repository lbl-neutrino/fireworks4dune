#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimFor2x2_v3.yaml specs/MiniRun3/*.yaml

start=0
single_size=10240
spill_size=1024

scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MiniRun3_1E19_RHC.nu --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MiniRun3_1E19_RHC.rock --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MiniRun3_1E19_RHC.nu.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MiniRun3_1E19_RHC.rock.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_SpillBuild --base-env MiniRun3_1E19_RHC.spill --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env MiniRun3_1E19_RHC.convert2h5 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_LArND --base-env MiniRun3_1E19_RHC.larnd --size $spill_size --start $start

logdir=$SCRATCH/job_logs.MiniRun3_1E19_RHC
mkdir -p $logdir

sbatch -o $logdir/slurm-%j.txt --array=1-10 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.rock.slurm.sh
sbatch -o $logdir/slurm-%j.txt --array=1-2 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.nu.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.nu.hadd.slurm.sh
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.rock.hadd.slurm.sh

# took an hour
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.spill.slurm.sh

# took 15 minutes
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.convert2h5.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-12 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.larnd.slurm.sh
