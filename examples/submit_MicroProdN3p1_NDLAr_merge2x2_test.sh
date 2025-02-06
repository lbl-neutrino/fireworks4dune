#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr-merge2x2-test/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr-merge2x2-test/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr-merge2x2-test/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v4.yaml specs/MicroProdN3p1_NDLAr-merge2x2-test/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MicroProdN3p1_NDLAr-merge2x2-test/*.tmsreco.nu.yaml --replace


start=1
single_size=2560
spill_size=256


logdir=/pscratch/sd/m/mdolce/MicroProdN3p1-merge-2x2-test/logs_sbatch
mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v4_Genie --base-envMicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.genie.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-5 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.genie.nu rapidfire

#scripts/fwsub.py --runner SimForNDLAr_v4_Edep --base-env MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.edep.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.edep.nu rapidfire

#scripts/fwsub.py --runner SimForNDLAr_v4_Hadd --base-env MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.nu.hadd --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.nu.hadd rapidfire

#scripts/fwsub.py --runner SimForNDLAr_v4_SpillBuild --base-env MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.spill.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.spill.nu rapidfire

#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN3p1-merge2x2-test_NDLAr_2E18_FHC.tmsreco.nu rapidfire
