#!/bin/bash

# This script uses Docker to launch a container in which to run ROS

set -u # Treat empty variables as an error.

# Some useful values
user="bouchier"
home="/home/$user"
RM="--rm"

# support the -keep argument to not remove the container upon exit
if [ $# -ne 0 ]; then
  if [ $1 == "-keep" ]; then
    RM=""; shift 1; echo "not removing container"
  else
    echo "Usage: $0 [-keep]"; exit
  fi
fi    

echo "running docker with home " $home " user " $user 
docker run                                                     \
    --net=host                                                 \
    -t                                                         \
    ${RM}                                                      \
    --privileged                                               \
    -v $home/.bash_history:$home/.bash_history                 \
    -v $home/catkin_ws:$home/catkin_ws                         \
    -v $home/bag_files:$home/bag_files                         \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK):ro  \
    -v /tmp/.X11-unix:/tmp/.X11-unix                           \
    -v /tmp:/tmp                                               \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK                            \
    --user $user                                               \
    -w $home                                                   \
    -i                                                         \
    ${ACTIVE_DOCKER}                                           \
    $@
