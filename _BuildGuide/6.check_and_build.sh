#!/usr/bin/bash

rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic
read -p "Press any key to continue building ROS from source."

mkdir -p $ROS_INSTALL_PATH
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 --install-space $ROS_INSTALL_PATH
