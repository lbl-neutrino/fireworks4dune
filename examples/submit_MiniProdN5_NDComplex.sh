#!/usr/bin/env bash


set +o posix


#scripts/load_yaml.py specs/NDComplex_v1.yaml --replace

###################### 
## MiniProdN5p1

#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spill.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spill.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.convert2h5.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.convert2h5.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.larnd.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow2supera.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spine.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.tmsreco.full.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.tmsreco.full.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.caf.full.spineonly.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.caf.full.spineonly.sandstt.yaml --replace

#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow2supera.full.light.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.flow2supera.full.light.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spine.full.light.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.spine.full.light.sandstt.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.caf.full.light.spineonly.sanddrift.yaml --replace
#scripts/load_yaml.py specs/MiniProdN5_NDComplex/MiniProdN5p1_NDComplex_FHC.caf.full.light.spineonly.sandstt.yaml --replace

###################### 


start_sanddrift=1
start_sandstt=64001
single_size=64000
spill_size=6400


logdir=/pscratch/sd/d/dunepro/abooth/logs_sbatch/MiniProdN5
mkdir -p $logdir


###################### 
## MiniProdN5p1

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-3 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.genie.ndlarfid.sandstt rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Genie --base-env MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-3 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.genie.rockantindlarfid.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sanddrift --size $single_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.edep.ndlarfid.sandstt rapidfire

#scripts/fwsub.py --runner NDComplex_v1_Edep --base-env MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sandstt --size $single_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.edep.rockantindlarfid.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.hadd.ndlarfid.sandstt singleshot

#scripts/fwsub.py --runner NDComplex_v1_Hadd --base-env MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.hadd.rockantindlarfid.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_SpillBuild --base-env MiniProdN5p1_NDComplex_FHC.spill.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spill.full.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_SpillBuild --base-env MiniProdN5p1_NDComplex_FHC.spill.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spill.full.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_Convert2H5 --base-env MiniProdN5p1_NDComplex_FHC.convert2h5.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.convert2h5.full.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Convert2H5 --base-env MiniProdN5p1_NDComplex_FHC.convert2h5.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.convert2h5.full.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.larnd.full.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_LArND --base-env MiniProdN5p1_NDComplex_FHC.larnd.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.larnd.full.sandstt rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow.full.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Flow --base-env MiniProdN5p1_NDComplex_FHC.flow.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-7 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow.full.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift singleshot

#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p1_NDComplex_FHC.flow2supera.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow2supera.full.sandstt singleshot


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p1_NDComplex_FHC.spine.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spine.full.sandstt rapidfire


#scripts/fwsub.py --runner NDComplex_v1_TMSReco --base-env MiniProdN5p1_NDComplex_FHC.tmsreco.full.sanddrift --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.tmsreco.full.sanddrift rapidfire

#scripts/fwsub.py --runner NDComplex_v1_TMSReco --base-env MiniProdN5p1_NDComplex_FHC.tmsreco.full.sandstt --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.tmsreco.full.sandstt rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.spineonly --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.spineonly rapidfire

#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p1_NDComplex_FHC.caf.full.sandstt.spineonly --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-1 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.caf.full.sandstt.spineonly rapidfire


#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.light --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow2supera.full.sanddrift.light singleshot

#scripts/fwsub.py --runner NDComplex_v1_Flow2Supera --base-env MiniProdN5p1_NDComplex_FHC.flow2supera.full.sandstt.light --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-4 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.flow2supera.full.sandstt.light singleshot


#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.light --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spine.full.sanddrift.light rapidfire

#scripts/fwsub.py --runner NDComplex_v1_MLreco_Spine --base-env MiniProdN5p1_NDComplex_FHC.spine.full.sandstt.light --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_gpu.slurm.sh MiniProdN5p1_NDComplex_FHC.spine.full.sandstt.light rapidfire


#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.light.spineonly --size $spill_size --start $start_sanddrift
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.caf.full.sanddrift.light.spineonly singleshot

#scripts/fwsub.py --runner NDComplex_v1_CAFMaker --base-env MiniProdN5p1_NDComplex_FHC.caf.full.sandstt.light.spineonly --size $spill_size --start $start_sandstt
#sbatch -o ${logdir:-.}/slurm-%j.txt --array=1-2 -N 1 slurm/fw_cpu.slurm.sh MiniProdN5p1_NDComplex_FHC.caf.full.sandstt.light.spineonly singleshot

###################### 
