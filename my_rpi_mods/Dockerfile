ARG ROS_DISTRO=humble
FROM ros2_rpi as base
##########################
# Set username/passwd here
##########################
ARG CONFIGURED_USER=bouchier

ENV ROS_DISTRO=${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]

# Install Git and other utilities from us.archive.ubuntu.com
USER root
RUN apt-get -qq update
RUN apt-get -y upgrade
RUN apt-get -qq --no-install-recommends install xeyes
USER ${CONFIGURED_USER}


