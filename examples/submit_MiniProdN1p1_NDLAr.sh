#!/usr/bin/env bash

source admin/load_fireworks.sh

scripts/load_yaml.py specs/SimForNDLAr_v1.yaml specs/MiniProdN1p1_NDLAr/*.yaml

start=0
single_size=10240
spill_size=1024
logdir=$SCRATCH/job_logs.MiniProdN1p1_NDLAr_1E19_RHC

mkdir -p $logdir

scripts/fwsub.py --runner SimForNDLAr_v1_GenieEdep --base-env MiniProdN1p1_NDLAr_1E19_RHC.nu --size $single_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_GenieEdep --base-env MiniProdN1p1_NDLAr_1E19_RHC.rock --size $single_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_Hadd --base-env MiniProdN1p1_NDLAr_1E19_RHC.nu.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_Hadd --base-env MiniProdN1p1_NDLAr_1E19_RHC.rock.hadd --size $spill_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_SpillBuild --base-env MiniProdN1p1_NDLAr_1E19_RHC.spill --size $spill_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_Convert2H5 --base-env MiniProdN1p1_NDLAr_1E19_RHC.convert2h5 --size $spill_size --start $start
scripts/fwsub.py --runner SimForNDLAr_v1_LArND --base-env MiniProdN1p1_NDLAr_1E19_RHC.larnd --size $spill_size --start $start

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 4 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.rock rapidfire
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.nu rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.nu.hadd rapidfire
sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.rock.hadd rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 4 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.spill rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.convert2h5 rapidfire

sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-12 -N 4 slurm/fw_gpu.slurm.sh MiniProdN1p1_NDLAr_1E19_RHC.larnd rapidfire --timeout $((60*40))

