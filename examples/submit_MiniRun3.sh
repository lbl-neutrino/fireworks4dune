#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimFor2x2_v3.yaml specs/MiniRun3/*.yaml

start=0
single_size=10240
spill_size=1024
logdir=$SCRATCH/job_logs.MiniRun3_1E19_RHC

mkdir -p $logdir

scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MiniRun3_1E19_RHC.nu --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_GenieEdep --base-env MiniRun3_1E19_RHC.rock --size $single_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MiniRun3_1E19_RHC.nu.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Hadd --base-env MiniRun3_1E19_RHC.rock.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_SpillBuild --base-env MiniRun3_1E19_RHC.spill --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env MiniRun3_1E19_RHC.convert2h5 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_LArND --base-env MiniRun3_1E19_RHC.larnd --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Plots --base-env MiniRun3_1E19_RHC.plots --size $spill_size --start $start

scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow_v2 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow_v3 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow_v4 --size $spill_size --start $start

sbatch -o $logdir/slurm-%j.txt --array=1-10 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.rock.slurm.sh
sbatch -o $logdir/slurm-%j.txt --array=1-2 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.nu.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.nu.hadd.slurm.sh
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.rock.hadd.slurm.sh

# took an hour
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.spill.slurm.sh

# took 15 minutes
sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.convert2h5.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-12 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.larnd.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.flow.slurm.sh

sbatch -t 180 -o $logdir/slurm-%j.txt --array=1-1 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.plots.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-1 -N 1 slurm/MiniRun3/MiniRun3_1E19_RHC.flow_v2.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-3 -N 4 slurm/MiniRun3/MiniRun3_1E19_RHC.flow_v3.slurm.sh

sbatch -o $logdir/slurm-%j.txt --array=1-3 -N 4 slurm/fw_cpu.slurm.sh MiniRun3_1E19_RHC.flow_v4 rapidfire

scripts/load_yaml.py specs/MiniRun3/MiniRun3_1E19_RHC.convert2h5_v2.yaml specs/MiniRun3/MiniRun3_1E19_RHC.larnd_v2.yaml

scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env MiniRun3_1E19_RHC.convert2h5_v2 --size $spill_size --start $start
scripts/fwsub.py --runner SimFor2x2_v3_LArND --base-env MiniRun3_1E19_RHC.larnd_v2 --size $spill_size --start $start

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 2 -t 60 slurm/fw_cpu.slurm.sh MiniRun3_1E19_RHC.convert2h5_v2 rapidfire
# sbatch -d afterok:8466167_1 -o ${logdir:-.}/slurm-%j.txt --array=1-12 -N 4 slurm/fw_gpu.slurm.sh MiniRun3_1E19_RHC.larnd_v2 rapidfire --timeout $((60*40))
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-12 -N 4 slurm/fw_gpu.slurm.sh MiniRun3_1E19_RHC.larnd_v2 rapidfire --timeout $((60*40))

scripts/load_yaml.py specs/MiniRun3/MiniRun3_1E19_RHC.flow_v5.yaml
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow_v5 --size $spill_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 slurm/fw_cpu.slurm.sh MiniRun3_1E19_RHC.flow_v5 rapidfire

scripts/load_yaml.py specs/MiniRun3/MiniRun3C_1E19_RHC.plots.yaml
scripts/fwsub.py --runner SimFor2x2_v3_Plots --base-env MiniRun3C_1E19_RHC.plots --size $spill_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 120 slurm/fw_cpu.slurm.sh MiniRun3C_1E19_RHC.plots rapidfire

scripts/load_yaml.py specs/MiniRun3/MiniRun3_1E19_RHC.flow_v6.yaml
scripts/fwsub.py --runner SimFor2x2_v3_Flow --base-env MiniRun3_1E19_RHC.flow_v6 --size $spill_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 slurm/fw_cpu.slurm.sh MiniRun3_1E19_RHC.flow_v6 rapidfire

scripts/load_yaml.py specs/MiniRun3/MiniRun3D_1E19_RHC.plots.yaml
scripts/fwsub.py --runner SimFor2x2_v3_Plots --base-env MiniRun3D_1E19_RHC.plots --size $spill_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 -t 60 slurm/fw_cpu.slurm.sh MiniRun3D_1E19_RHC.plots rapidfire

scripts/load_yaml.py specs/MiniRun3/MiniRun3_1E19_RHC.convert2h5_v3.yaml
scripts/fwsub.py --runner SimFor2x2_v3_Convert2H5 --base-env MiniRun3_1E19_RHC.convert2h5_v3 --size $spill_size --start $start
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 2 -t 60 slurm/fw_cpu.slurm.sh MiniRun3_1E19_RHC.convert2h5_v3 rapidfire


# remember: lpad admin tuneup --full
