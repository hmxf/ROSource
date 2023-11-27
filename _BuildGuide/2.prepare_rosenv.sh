#!/usr/bin/bash

sudo sh -c 'echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update

sudo apt install build-essential  libgoogle-glog-dev hugin-tools enblend glibc-doc
sudo apt install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool python3-catkin-tools

sudo rosdep init
rosdep update
