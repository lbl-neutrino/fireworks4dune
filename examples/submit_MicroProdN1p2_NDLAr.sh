#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.genie.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.edep.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.hadd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.spill.nu.yaml --replace
#scripts/load_yaml.py specs/ND_Production_v1.yaml specs/MicroProdN1p2_NDLAr/*.tmsreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.convert*.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.larnd.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.flow.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.mlreco.nu.yaml --replace
#scripts/load_yaml.py specs/SimForNDLAr_v3.yaml specs/MicroProdN1p2_NDLAr/*.caf.nu.yaml --replace

start=1
single_size=1280
spill_size=128

logdir=/pscratch/sd/a/abooth/MicroProdN1p2/logs_sbatch
mkdir -p $logdir


#scripts/fwsub.py --runner SimForNDLAr_v3_Genie --base-env MicroProdN1p2_NDLAr_1E18_RHC.genie.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.genie.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_Edep --base-env MicroProdN1p2_NDLAr_1E18_RHC.edep.nu --size $single_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.edep.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_Hadd --base-env MicroProdN1p2_NDLAr_1E18_RHC.hadd.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.hadd.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_SpillBuild --base-env MicroProdN1p2_NDLAr_1E18_RHC.spill.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.spill.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_Convert2H5 --base-env MicroProdN1p2_NDLAr_1E18_RHC.convert2h5.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.convert2h5.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_LArND --base-env MicroProdN1p2_NDLAr_1E18_RHC.larnd.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_gpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.larnd.nu rapidfire


#scripts/fwsub.py --runner ND_Production_v1_TMSReco --base-env MicroProdN1p2_NDLAr_1E18_RHC.tmsreco.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.tmsreco.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_Flow --base-env MicroProdN1p2_NDLAr_1E18_RHC.flow.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-16 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.flow.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_Flow2Supera --base-env MicroProdN1p2_NDLAr_1E18_RHC.flow2supera.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.flow2supera.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_MLreco_Inference --base-env MicroProdN1p2_NDLAr_1E18_RHC.mlreco_inference.nu --size $spill_size --start $start
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_gpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.mlreco_inference.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_MLreco_Analysis --base-env MicroProdN1p2_NDLAr_1E18_RHC.mlreco_analysis.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.mlreco_analysis.nu rapidfire


#scripts/fwsub.py --runner SimForNDLAr_v3_CAFmaker --base-env MicroProdN1p2_NDLAr_1E18_RHC.caf.nu --size $spill_size --start $start
#sbatch -o "$logdir"/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MicroProdN1p2_NDLAr_1E18_RHC.caf.nu rapidfire

