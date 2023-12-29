#!/usr/bin/env bash
# source me from root of fireworks4dune

module load python/3.11
module load mongodb

fw4dune_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

source "$fw4dune_dir"/fw.venv/bin/activate

export FW_CONFIG_FILE="$fw4dune_dir"/fw_config/FW_config.yaml

# by default, production script repos go in the parent directory of
# fireworks4dune
if [ -z "$FW4DUNE_REPO_DIR" ]; then
    FW4DUNE_REPO_DIR=$(realpath "$fw4dune_dir"/..)
    export FW4DUNE_REPO_DIR
fi
