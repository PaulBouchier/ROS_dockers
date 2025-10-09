#!/bin/bash

# This script uses Docker to launch a container in which to run ROS

set -u # Treat empty variables as an error.

RM="--rm"

# support the -keep argument to not remove the container upon exit
if [ $# -ne 0 ]; then
  if [ $1 == "-keep" ]; then
    RM=""; shift 1; echo "not removing container"
  else
    echo "Usage: $0 [-keep]"; exit
  fi
fi    

echo "running ${ACTIVE_DOCKER} docker with home " $HOME " user " $USER 
docker run                                                     \
    --net=host                                                 \
    -t                                                         \
    ${RM}                                                      \
    --privileged                                               \
    -v $HOME/.bash_history:$HOME/.bash_history                 \
    -v $HOME/ros2_ws:$HOME/ros2_ws                             \
    -v $HOME/ws_rmw_zenoh:$HOME/ws_rmw_zenoh                             \
    -v $HOME/bag_files:$HOME/bag_files                         \
    -v /tmp/.X11-unix:/tmp/.X11-unix                           \
    -v /tmp:/tmp                                               \
    --user $USER                                               \
    -w $HOME                                                   \
    -i                                                         \
    ${ACTIVE_DOCKER}                                           \
    $@

