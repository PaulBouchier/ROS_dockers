# ROS_dockers

This repo contains Dockerfiles useful for running ROS in different
contexts (ros1/2, different hosts, etc). The Dockerfiles use a ROS_DISTRO
argument that enables building different ROS releases.

The following docker builds are provided:
- ros2_x86_linux - A docker image that provides ros2-humble on x86 linux platforms (e.g. Ubuntu 22.04).
- ros1_x86_linux - A docker image that provides ros-noetic on x86 linux platforms (e.g. Ubuntu 22.04).
- ros2_rpi - A docker image that provides ros2-humble on Raspberry Pi OS
- ros1_rpi - A docker image that provides ros-noetic on Raspberry Pi OS

The repo should be supported by the following environment variables and aliases in .bashrc:

    # Docker aliases
    export PATH_TO_ROS_DOCKERS='${HOME}/Documents/Robotics/ROS_dockers'
    export ACTIVE_DOCKER=ros2_x86_linux

    alias docker_build='cd ${PATH_TO_ROS_DOCKERS}/${ACTIVE_DOCKER} && docker build -t ${ACTIVE_DOCKER}'
    alias dr='cd ${PATH_TO_ROS_DOCKERS}/${ACTIVE_DOCKER} && ./run_it.sh $@'
    alias dsl='docker start -ai `docker ps -lq`'
    alias de='docker exec -it `docker ps -lq` bash'

# Intended Use-model

Use models different than described here are possible. They are discussed later.

It is intended that the docker image should be built with the docker_build
alias, with the ACTIVE_DOCKER environment variable having been set
beforehand. This will produce an image named by the ${ACTIVE_DOCKER}
variable.  The initial value of the ACTIVE_DOCKER variable should be set in .bashrc.

The docker containers built by these dockerfiles are intended to run
and debug ROS software.  The ROS source code and build products in
the ROS workspace are preserved on the host filesystem. The container is
removed after it exits, and changes made inside the container are lost,
unless the -keep flag is given to the run_it.sh script. The -keep flag can be useful
to (temporarily) preserve changes in the container (e.g. changes to .bashrc) until the
changes - if accepted - are put into the Dockerfile and the image rebuilt. Restart
the modified container with the dsl alias.

A disadvantage of this use-model is the user needs to be competent to implement
container changes in the Dockerfile.

## Alternate Use-model

It is possible to preserve containers when they exit. This is the default
docker behavior.  The container would be restarted when needed and would
contain any changes made to it when it was last run. The advantage is
that changes made in the container are preserved. The disadvantage is
the changes can be forgotten if not added to the Dockerfile, and be
lost next time the image is rebuilt with some other change. This can
lead to regressions. It also means there needs to be two ways to run:
run-from-image, and run-container, both of which are used in different
circumstances.

# Bashrc Environment and Aliases

The bash environment variables should be set as needed based on your environment:

- PATH_TO_ROS_DOCKERS: the location where you checked out this repo, and where you will build and
run the dockers
- ACTIVE_DOCKER: the image name and directory name where the image is built

The run_it.sh script launches the container with options appropriate to the kind of container
and environment.

## dr (docker run) alias

After building the docker image with docker_build, the image should be
run in a container with the dr (docker run) alias. Each time dr is run,
a new container will be generated, and any changes made to the previous
container will be lost unless the -keep option was given. The dr alias
"starts fresh" with a new container that runs what the Dockerfile built.

## dsl (docker start last) alias
The dsl alias will re-start the last-kept docker container. When combined with the -keep flag
to run_it.sh, the Alternate Use-model is enabled.

## de (docker execute) alias
The de alias can be run when a docker container is running. It provides an interactive shell in the
currently running docker.

