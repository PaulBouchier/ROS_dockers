ARG ROS_DISTRO=humble

FROM osrf/ros:${ROS_DISTRO}-desktop-full-jammy as base
ENV ROS_DISTRO=${ROS_DISTRO}

##########################
# Set username/passwd here
##########################
ARG CONFIGURED_USER=bouchier
ARG CONFIGURED_PASSWD=Docker

SHELL ["/bin/bash", "-c"]

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install Git and other utilities from us.archive.ubuntu.com
RUN apt-get -qq update
RUN apt-get -y upgrade
RUN apt-get -qq --no-install-recommends install apt-utils
RUN apt-get -qq --no-install-recommends install git vim-gtk3 sudo less \
  && apt-get -qq --no-install-recommends install inetutils-ping inetutils-traceroute net-tools \
  && apt-get -qq --no-install-recommends install xterm terminator \
  && apt-get -qq --no-install-recommends install python-is-python3 \
  && apt-get -qq --no-install-recommends install python3-pip \
  && apt-get -qq --no-install-recommends install software-properties-common

# Install needed ROS packages
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-swri-console
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-plotjuggler
RUN apt-get -qq --no-install-recommends install python3-colcon-common-extensions
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-tf-transformations
RUN pip3 install transforms3d
RUN apt-get -qq --no-install-recommends install nano

# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Setup the default user.
RUN groupadd ${CONFIGURED_USER} && useradd -ms /bin/bash -g ${CONFIGURED_USER} ${CONFIGURED_USER}
RUN adduser ${CONFIGURED_USER} sudo
RUN echo ${CONFIGURED_USER}\:${CONFIGURED_USER}\ root\:${CONFIGURED_PASSWD} | chpasswd

# Use ccache
ENV USE_CCACHE 1
ENV NDK_CCACHE /usr/bin/ccache
ENV CCACHE_DIR /opt/workspace/ccache
ENV PATH /usr/lib/ccache:$PATH

ENV QT_GRAPHICSSYSTEM native

# add environment changes to .bashrc
WORKDIR /home/${CONFIGURED_USER}
USER ${CONFIGURED_USER}
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ${CONFIGURED_USER} /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown ${CONFIGURED_USER} /ros_entrypoint.sh ;

# startup environment
WORKDIR /home/${CONFIGURED_USER}
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

