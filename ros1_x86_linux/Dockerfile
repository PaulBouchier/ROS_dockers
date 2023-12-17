ARG ROS_DISTRO=noetic
FROM osrf/ros:${ROS_DISTRO}-desktop-full as base
ENV ROS_DISTRO=${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install Git and other utilities from us.archive.ubuntu.com
COPY ./config/sources.list /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -y upgrade
RUN apt-get -qq --no-install-recommends install apt-utils
RUN apt-get -qq --no-install-recommends install git
RUN apt-get -qq --no-install-recommends install vim-gtk3
RUN apt-get -qq --no-install-recommends install sudo less \
  && apt-get -qq --no-install-recommends install inetutils-ping inetutils-traceroute net-tools \
  && apt-get -qq --no-install-recommends install xterm terminator \
  && apt-get -qq --no-install-recommends install python-is-python3 \
  && apt-get -qq --no-install-recommends install python3-pip \
  && apt-get -qq --no-install-recommends install software-properties-common

# Install needed ROS packages
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-swri-console
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-plotjuggler
RUN apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-xacro \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-robot-state-publisher \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-mavros-msgs \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-nmea-msgs \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-costmap-2d \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-grid-map-ros \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-grid-map-filters \
  && apt-get -qq --no-install-recommends install ros-${ROS_DISTRO}-grid-map-core

# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Setup the default user.
RUN groupadd bouchier && useradd -ms /bin/bash -g bouchier bouchier
RUN adduser bouchier sudo
RUN echo 'bouchier:bouchier root:Paul129' | chpasswd
#RUN mkdir -p /home/bouchier
RUN echo `ls -l /home`
RUN echo `grep bouchier /etc/passwd`
#RUN echo `grep bouchier /etc/group`
#RUN chown -R bouchier:root /home/bouchier
RUN echo `ls -als /home`
RUN echo `ls -als /home/bouchier`

# Install GeographicLib
USER bouchier
RUN mkdir -p /home/bouchier/packages
COPY config/GeographicLib-2.3.tar.gz /home/bouchier/packages
COPY config/install_GeographicLib /home/bouchier/packages
WORKDIR /home/bouchier/packages
RUN ./install_GeographicLib

# Use ccache
ENV USE_CCACHE 1
ENV NDK_CCACHE /usr/bin/ccache
ENV CCACHE_DIR /opt/workspace/ccache
ENV PATH /usr/lib/ccache:$PATH

ENV QT_GRAPHICSSYSTEM native

# add environment changes to .bashrc
WORKDIR /home/bouchier
USER bouchier
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown bouchier /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh ; sudo chown bouchier /ros_entrypoint.sh ;

# Set up catkin workspace
RUN mkdir -p /home/bouchier/catkin_ws/src && chown -R bouchier:bouchier /home/bouchier/catkin_ws
WORKDIR /home/bouchier/catkin_ws
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash; catkin_make"

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* 

# startup environment
WORKDIR /home/bouchier
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

