#!/usr/bin/env bash

source admin/load_fireworks.sh

rlaunch_to() {
    name=$1; shift
    yaml=$(mktemp --suffix=.yaml)
    cat > "$yaml" <<EOF
name: '$name'
category: '$name'
query: '{}'
EOF
    rlaunch -w "$yaml" "$@"
    rm "$yaml"
}

scripts/load_yaml.py specs/SimFor2x2_v2.yaml specs/MiniRun2/*.yaml


scripts/fwsub.py --runner SimFor2x2_v2_GenieEdep --base-env MiniRun2_1E19_RHC_nu --size 1

rlaunch_to MiniRun2_1E19_RHC_nu singleshot


scripts/fwsub.py --runner SimFor2x2_v2_GenieEdep --base-env MiniRun2_1E19_RHC_rock --size 1

rlaunch_to MiniRun2_1E19_RHC_rock singleshot


scripts/fwsub.py --runner SimFor2x2_v2_SpillBuild --base-env MiniRun2_1E19_RHC_spill --size 1

rlaunch_to MiniRun2_1E19_RHC_spill singleshot


scripts/fwsub.py --runner SimFor2x2_v2_Convert2H5 --base-env MiniRun2_1E19_RHC_convert2h5 --size 1

rlaunch_to MiniRun2_1E19_RHC_convert2h5 singleshot


scripts/fwsub.py --runner SimFor2x2_v2_LArND --base-env MiniRun2_1E19_RHC_larnd --size 1

rlaunch_to MiniRun2_1E19_RHC_larnd singleshot
