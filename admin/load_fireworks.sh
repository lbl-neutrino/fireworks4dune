#!/usr/bin/env bash
# source me from root of fireworks4dune

module load python
module load mongodb

source fw.venv/bin/activate

export FW_CONFIG_FILE=$(realpath fw_config/FW_config.yaml)

# by default, production script repos go in the parent directory of
# fireworks4dune
if [ ! -n "$FW4DUNE_REPO_DIR" ]; then
    export FW4DUNE_REPO_DIR=$(realpath ..)
fi
