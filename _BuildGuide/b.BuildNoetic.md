# 编译安装 ROS Noetic

在完成了预安装指南中的所有步骤后，本指南可指导你继续完成 `ROS Noetic` 的编译和安装步骤

- 更新 ROS 源码目录

    ```bash
    mv noetic-ALL.rosinstall noetic-ALL.rosinstall.old && chmod -w noetic-ALL.rosinstall.old
    rosinstall_generator ALL --rosdistro noetic --deps --tar > noetic-ALL.rosinstall
    ```

- ***需要完成一个脚本，该脚本用于将目的文件与源文件对比，并询问是否将源文件的对应内容写入目的文件***

    使用 `update_source.py` 脚本完成对源码的更新

    ```bash
    python3 update_source.py --destnation-file=noetic-AgRobot.rosinstall --source-file=noetic-ALL.rosinstall
    ```

    脚本运行后会自动对比 `--destnation-file` 中的内容与 `--source-file` 中的同名字段是否完全一致，如果不一致则询问用户是否用 `--source-file` 中的新内容替换 `--destnation-file` 的同名字段。

- 添加依赖

    可以在 `noetic-ALL.rosinstall` 文件中使用全文搜索来快速获取所需要包的信息，也可以在 [ROS Index](https://index.ros.org/packages/) 中查询目标包及其依赖包的信息。两种方法均可，但更推荐第一种方法，详情可参考 [如何手动解决依赖问题](Guide_for_resolving_dependencies_by_hand.md)。

    - 通过修改 `.rosinstall` 文件添加需要的依赖
    
        将依赖包信息写入文本文件的示例参见 [prerequisite_packages_demo.txt](prerequisite_packages_demo.txt)，该文件按照 `.rosinstall` 文件格式编写，整理完成后可以使用 `cat` 命令写入  `noetic-desktop_full.rosinstall` 文件从而完成依赖包的批量添加。

    - 通过 `git clone` 方式添加：

        ```bash
        cd src && git clone https://github.com/wjwwood/serial && cd serial && git checkout 1.2.1 && cd ../..
        ```

- 获取源码

    **每次修改 `noetic-AgRobot.rosinstall` 文件之后，都必须通过以下命令重新获取源码包并执行后续步骤**。

        ```bash
        mkdir src
        vcs import --input noetic-AgRobot.rosinstall ./src
        ```

- 检查依赖情况

    执行该步骤需要时刻注意终端提示内容，如果需要通过 apt 安装 `ros-noetic-*` 包，需要取消安装并记录这些包，再从 `添加依赖` 步骤开始重新分析依赖关系并获取源码，直到以下命令提示所有依赖都可以满足。

    ```bash
    rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic
    #All required rosdeps installed successfully
    ```

- 创建编译目标路径并编译安装 ROS

    在 Ubuntu 系统中，通过 APT 安装的 ROS 默认路径位于 `/opt/ros/noetic` 中，因此强烈不建议将源码编译的 ROS 环境同样定位到该路径，建议选择其他有写入权限的路径。

    ```bash
    mkdir -p $ROS_INSTALL_PATH
    ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 --install-space $ROS_INSTALL_PATH
    ```
