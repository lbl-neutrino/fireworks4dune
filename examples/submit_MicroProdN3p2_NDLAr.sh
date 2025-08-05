#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace
#scripts/load_yaml.py specs/MicroProdN3p2_NDLAr/MicroProdN3p2_NDLAr_2E22_FHC_NuE.larnd.ndlarfid.singles.yaml --replace
#scripts/load_yaml.py specs/MicroProdN3p2_NDLAr/MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow.ndlarfid.singles.yaml --replace
#scripts/load_yaml.py specs/MicroProdN3p2_NDLAr/MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow2supera.ndlarfid.singles.yaml --replace


start=1
single_size=25600
spill_size=2560


logdir=/pscratch/sd/d/dunepro/abooth/logs_sbatch/MicroProdN3p2
mkdir -p $logdir


#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MicroProdN3p2_NDLAr_2E22_FHC_NuE.larnd.ndlarfid.singles --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MicroProdN3p2_NDLAr_2E22_FHC_NuE.larnd.ndlarfid.singles rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow.ndlarfid.singles --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow.ndlarfid.singles singleshot


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow2supera.ndlarfid.singles --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p2_NDLAr_2E22_FHC_NuE.flow2supera.ndlarfid.singles singleshot


