#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.spill.singles.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MicroProdN3p4_NDLAr/*.tmsreco.singles.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.convert*.singles.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.larnd.singles.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p4_NDLAr/*.flow.singles.nu.yaml --replace


start=1
#single_size=2560
single_size=5120
#spill_size=256
spill_size=5120


logdir=/pscratch/sd/a/abooth/MicroProdN3p4/logs_sbatch
mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-env MicroProdN3p4_NDLAr_2E18_FHC.genie.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.genie.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN3p4_NDLAr_2E18_FHC.edep.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.edep.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN3p4_NDLAr_2E18_FHC.hadd.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.hadd.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN3p4_NDLAr_2E18_FHC.spill.singles.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.spill.singles.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MicroProdN3p4_NDLAr_2E18_FHC.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.tmsreco.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Convert2H5 --base-env MicroProdN3p4_NDLAr_2E18_FHC.convert2h5.singles.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-6 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.convert2h5.singles.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_LArND --base-env MicroProdN3p4_NDLAr_2E18_FHC.larnd.geomfix.singles.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-55 -N 1 slurm/fw_gpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.larnd.geomfix.singles.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v4_Flow --base-env MicroProdN3p4_NDLAr_2E18_FHC.flow.geomfix.singles.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-10 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p4_NDLAr_2E18_FHC.flow.geomfix.singles.nu rapidfire
