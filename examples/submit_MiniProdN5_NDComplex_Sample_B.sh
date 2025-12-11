#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace


######################
## MiniProdN5p1, Sample B.

#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.caf.full.spineonly.sanddrift.nueelastic.overlay.yaml --replace

######################

######################
## MiniProdN5p2, Sample B.

#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p2_NDComplex_RHC.larnd.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p2_NDComplex_RHC.flow.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p2_NDComplex_RHC.flow2supera.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p2_NDComplex_RHC.spine.full.sanddrift.nueelastic.overlay.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p2_NDComplex_RHC.caf.full.spineonly.sanddrift.nueelastic.overlay.yaml --replace

######################


start_sanddrift=1
single_size=64000
spill_size=6400
#start_sanddrift=1
#single_size=16000
#spill_size=1600


logdir=/pscratch/sd/d/dunepro/kjvocker/logs_sbatch/MiniProdN5
mkdir -p $logdir


######################
## MiniProdN5p1, Sample B.

#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.nueelastic.overlay.spineonly --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.nueelastic.overlay.spineonly rapidfire

######################


######################
## MiniProdN5p2, Sample B.

#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MiniProdN5p2_NDComplex_RHC.larnd.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p2_NDComplex_RHC.larnd.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MiniProdN5p2_NDComplex_RHC.flow.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p2_NDComplex_RHC.flow.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p2_NDComplex_RHC.flow2supera.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p2_NDComplex_RHC.flow2supera.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p2_NDComplex_RHC.spine.full.sanddrift.nueelastic.overlay --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p2_NDComplex_RHC.spine.full.sanddrift.nueelastic.overlay rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p2_NDComplex_RHC.caf.full.sanddrift.nueelastic.overlay.spineonly --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p2_NDComplex_RHC.caf.full.sanddrift.nueelastic.overlay.spineonly rapidfire

######################

