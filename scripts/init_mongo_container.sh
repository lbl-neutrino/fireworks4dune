#!/bin/bash

# Need older version for correct --userns behaviour
export PODMANHPC_PODMAN_BIN=/global/common/shared/das/podman-4.7.0/bin/podman

# Create directory for DB
FW4DUNE_DIR=${FW4DUNE_DIR:-$PWD}
MOUNT_DB_DIR=${MONGODB_LOCAL_DIR:-"$FW4DUNE_DIR/mongo_db"}

if [ ! -d "${MOUNT_DB_DIR}" ]; then
    echo "Creating ${MOUNT_DB_DIR}"
    mkdir -p ${MOUNT_DB_DIR}
fi

# Something to prevent an error when running on compute node
if [ -n "$SLURM_JOB_ID" ]; then
    podman-hpc system migrate
fi

# Start new MongoDB container and bind to local MongoDB directory
# The username and password can be set below
NODE_PORT=55555
CONTAINER_NAME="fireworks_db"
podman-hpc --log-level=debug \
        run -d \
	--replace \
	--name ${CONTAINER_NAME} \
       	-p ${NODE_PORT}:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=root \
	-e MONGO_INITDB_ROOT_PASSWORD="" \
	--userns=keep-id \
	-v ${MOUNT_DB_DIR}:/data/db:U,Z \
	docker.io/library/mongo:latest
