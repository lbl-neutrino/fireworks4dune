#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace


######################
## MiniProdN5p1, Sample C.

#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spill.full.lowintensity.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.convert2h5.full.lowintensity.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.larnd.full.lowintensity.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow.full.lowintensity.sanddrift.yaml --replace

######################


start_sanddrift=1
spill_size=2000


logdir=/pscratch/sd/d/dunepro/yuxuan/logs_sbatch/MiniProdN5
mkdir -p $logdir


######################
## MiniProdN5p1, Sample C.

#scripts/fwsub.py --runner NDComplex_v1_SpillBuild --base-env MiniProdN5p1_NDComplex_FHC.spill.full.lowintensity.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spill.full.lowintensity.sanddrift rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Convert2H5 --base-env MiniProdN5p1_NDComplex_FHC.convert2h5.full.lowintensity.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.convert2h5.full.lowintensity.sanddrift rapidfire


#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MiniProdN5p1_NDComplex_FHC.larnd.full.lowintensity.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.larnd.full.lowintensity.sanddrift rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MiniProdN5p1_NDComplex_FHC.flow.full.lowintensity.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow.full.lowintensity.sanddrift rapidfire

######################

