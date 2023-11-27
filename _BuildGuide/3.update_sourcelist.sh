#!/usr/bin/bash

mv noetic-ALL.rosinstall noetic-ALL.rosinstall.old && chmod -w noetic-ALL.rosinstall.old
mv noetic-ALL.rosinstall noetic-AgRobot.rosinstall.old && chmod -w noetic-AgRobot.rosinstall.old
mv noetic-ALL.rosinstall noetic-desktop_full.rosinstall.old && chmod -w noetic-desktop_full.rosinstall.old
rosinstall_generator ALL --rosdistro noetic --deps --tar > noetic-ALL.rosinstall
rosinstall_generator desktop_full --rosdistro noetic --deps --tar > noetic-desktop_full.rosinstall

#python3 update_source.py --destnation-file=noetic-AgRobot.rosinstall --source-file=noetic-ALL.rosinstall
