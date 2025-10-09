ARG ROS_DISTRO=jazzy

FROM osrf/ros:${ROS_DISTRO}-desktop-full-noble AS base
ENV ROS_DISTRO=${ROS_DISTRO}
ENV TZ="America/Chicago"

SHELL ["/bin/bash", "-c"]

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install Git and other utilities from us.archive.ubuntu.com
RUN apt-get -qq update
RUN apt-get -y upgrade
#RUN apt-get -qq --no-install-recommends install apt-utils
RUN apt-get -qq --no-install-recommends install git vim-gtk3 sudo less \
  && apt-get -qq --no-install-recommends install inetutils-ping inetutils-traceroute net-tools \
  && apt-get -qq --no-install-recommends install xterm terminator \
  && apt-get -qq --no-install-recommends install python-is-python3 \
  && apt-get -qq --no-install-recommends install python3-pip \
  && apt-get -qq --no-install-recommends install software-properties-common

# Install needed ROS packages
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-swri-console
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-plotjuggler
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-plotjuggler-ros
RUN apt-get -qq --no-install-recommends install python3-colcon-common-extensions
RUN apt-get -qq --no-install-recommends install nano

# no jazzy release of the following
RUN apt-get -qq --no-install-recommends install python3-transforms3d
#RUN pip install setuptools==58.2.0

# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Setup the default user.
##########################
# Set username/passwd here
##########################
ARG CONFIGURED_USER=bouchier
ARG CONFIGURED_PASSWD=Docker
ARG DISPLAY=:1
ENV DISPLAY=${DISPLAY}

# for 24.04 there is a default user "ubuntu with UID/GID 1000. Change this user & group to ${CONFIGURED_USER}
RUN usermod -l ${CONFIGURED_USER} -d /home/${CONFIGURED_USER} ubuntu
RUN groupmod -n ${CONFIGURED_USER} ubuntu
RUN cp -r /home/ubuntu /home/${CONFIGURED_USER}
RUN chown ${CONFIGURED_USER}:${CONFIGURED_USER} /home/${CONFIGURED_USER}
RUN chown ${CONFIGURED_USER}:${CONFIGURED_USER} /home/${CONFIGURED_USER}/.?*
#RUN groupadd -${CONFIGURED_USER} && useradd -ms /bin/bash -g ${CONFIGURED_USER} ${CONFIGURED_USER}
#RUN adduser ${CONFIGURED_USER} sudo
RUN echo ${CONFIGURED_USER}\:${CONFIGURED_USER}\ root\:${CONFIGURED_PASSWD} | chpasswd

# Use ccache
ENV USE_CCACHE=1
ENV NDK_CCACHE=/usr/bin/ccache
ENV CCACHE_DIR=/opt/workspace/ccache
ENV PATH=/usr/lib/ccache:$PATH

ENV QT_GRAPHICSSYSTEM=native

# add environment changes to .bashrc
WORKDIR /home/${CONFIGURED_USER}
USER ${CONFIGURED_USER}
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ${CONFIGURED_USER} /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# run rosdep update
RUN rosdep update

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ${CONFIGURED_USER} /ros_entrypoint.sh ;

# startup environment
WORKDIR /home/${CONFIGURED_USER}
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

