# 如何手动解决依赖

以 [imu_gps_fusion](https://github.com/hmxf/imu_gps_fusion) 仓库为例，根据仓库中的描述，需要预先安装 `ros-noetic-catkin-virtualenv`、`ros-noetic-gps-common`、`ros-noetic-navigation`和`ros-noetic-move-base`四个包。解决依赖的具体步骤如下：

- 查询各包的依赖，有以下三种方法，酌情选用

    1. 递归查询每个软件包的 `package.xml` 文件并记录其所需要的依赖，去重后分别查询其是否存在于 `noetic-desktop_full.rosinstall` 文件中。但人工查询在依赖树较为庞大时效率极低，推荐采用具备此类功能的脚本或程序自动化完成这一步骤。

    2. 当依赖树较为简单、依赖数量不多时，可以采用手动方式完成查询工作。

    3. 通过比对全部 ROS 包源码索引、本地已有的 ROS 包源码索引和所缺乏的包名列表，手动修改 `noetic-desktop_full.rosinstall` 文件并加入需要但没有的包信息，进而自动地完成 ROS 新包的添加和环境的更新。

    本例将以第二种方法为主、结合使用前两种方法作为示例来演示添加新源码包的流程，**实际上该演示并没有完全解决依赖问题，仅作为流程说明**。作为对前两种方法的结合和延伸，在理解了 `rosinstall_generator` 和 `vcs` 工具在整个源码获取流程中的作用和协作方式后，第三种方法是效率最高的方案，本例也使用该方法完全满足了依赖关系，因此推荐在熟悉前两种方法后尽早学会应用第三种方法解决大型项目中的依赖问题。

- 查询包管理器中各包的版本

    ```bash
    apt search ros-noetic-catkin-virtualenv
        ros-noetic-catkin-virtualenv/focal 0.6.1-2focal.20210726.195032 arm64
    apt search ros-noetic-gps-common
        ros-noetic-gps-common/focal 0.3.4-1focal.20230620.193541 arm64
    apt search ros-noetic-navigation
        ros-noetic-navigation/focal 1.17.3-1focal.20231013.225901 arm64
    apt search ros-noetic-move-base
        ros-noetic-move-base/focal 1.17.3-1focal.20231013.201001 arm64
    ```

- 在 ROS WiKi 中查询各包的源代码地址

    ```
    ros-noetic-catkin-virtualenv    https://github.com/locusrobotics/catkin_virtualenv
    ros-noetic-gps-common           https://github.com/swri-robotics/gps_umd
    ros-noetic-navigation           https://github.com/ros-planning/navigation
    ros-noetic-move-base            https://github.com/ros-planning/navigation
    ```

- 阅读以上各代码仓库中特定版本代码中的 `package.xml` 文件，其中前两个包的所有依赖都已满足，后两个包则在源于同一个仓库，且还有一个对 `move_base_msgs` 的依赖没有满足，对其的查询使我们找到了 `ros-noetic-navigation-msgs` 这个包

    ```
    ros-noetic-navigation-msgs      https://github.com/ros-planning/navigation_msgs
    ```

    该仓库中包含了 `map_msgs` 和 `move_base_msgs` 两个包，而在 `noetic-desktop_full.rosinstall` 文件中则只有前者存在，因此我们需要将后者也添加到源码中

- 此时项目依赖树如下

    - [imu_gps_fusion](https://github.com/hmxf/imu_gps_fusion)
        - [ros-noetic-catkin-virtualenv](https://github.com/locusrobotics/catkin_virtualenv/tree/0.6.1)
        - [ros-noetic-gps-common](https://github.com/swri-robotics/gps_umd/tree/0.3.4)
        - [ros-noetic-navigation 和 ros-noetic-move-base](https://github.com/ros-planning/navigation/tree/1.17.3)
            - [ros-noetic-navigation-msgs](https://github.com/ros-planning/navigation_msgs/tree/1.14.1)
                - map_msgs
                - move_base_msgs

- 除 `ros-noetic-navigation-msgs` 之外的其余依赖较易获取，它们的共同点是 `noetic-desktop_full.rosinstall` 文件并未对这些包作出声明。
    
    包 `ros-noetic-navigation-msgs` 的处理方式较为特殊。在 `获取 ROS 源码` 步骤中生成的 `noetic-desktop_full.rosinstall` 文件中，虽然指明了需要安装版本为 `1.14.1` 的 `map_msgs` 包，在 `src/navigation_msgs` 路径下也有 `map_msgs` 文件夹，但 `noetic-desktop_full.rosinstall` 文件没有提及 `ros-noetic-move-base-msgs` 包，`src/navigation_msgs` 路径下也没有 `move_base_msgs` 文件夹。虽然可以通过删除 `src/navigation_msgs` 文件夹再重新获取全部源码的方式来获得 `ros-noetic-move-base-msgs` 包，但这种方式每次更新都需要手动获取源码，而且对源码的改动未能同步给 `noetic-desktop_full.rosinstall` 文件也使得该方法可能容易引发其他问题。

    若执意通过修改源码的方式安装完整的 ```navigation_msgs``` 包但不向 `noetic-desktop_full.rosinstall` 文件添加相关信息，可以使用以下命令：

    ```bash
    rm -rf src/navigation_msgs && cd src && git clone https://github.com/ros-planning/navigation_msgs && cd navigation_msgs && git checkout 1.14.1 && cd ../..
    ```

    **注意：每次在执行 `获取 ROS 源码` 后 `noetic-desktop_full.rosinstall` 文件的 `navigation_msgs` 相关 Tag 都有可能被更新，包括但不限于对子模块的版本、路径甚至是数目，因此需要在还未执行 `解决依赖` 步骤前修改相关内容，修改后务必确保所有依赖关系都已被满足方可继续执行编译安装步骤。**

    若希望使用一些更加优雅的方式，可以考虑使用以下方案。该方案希望通过对 `noetic-desktop_full.rosinstall` 文件做修改从而尽可能让编译出来的 ROS 环境符合预期且易于更新。因此，更新 `noetic-desktop_full.rosinstall` 文件的命令需要完成的功能有：

    - 在 `map_msgs` 包后插入 `move_base_msgs` 包的信息
    - 保证 `move_base_msgs` 包的版本与 `map_msgs` 包一致

    因此，可以在 `noetic-desktop_full.rosinstall` 文件中搜索 `map_msgs` 并将其所在段落的内容整体复制并插入到该段落后，再修改其中的包名即可，例如：

    ```bash
    nano noetic-desktop_full.rosinstall
    ```

    - 当前版本 `map_msgs` 的包信息如下：

        ```
        - tar:
            local-name: navigation_msgs/map_msgs
            uri: https://github.com/ros-gbp/navigation_msgs-release/archive/release/noetic/map_msgs/1.14.1-1.tar.gz
            version: navigation_msgs-release-release-noetic-map_msgs-1.14.1-1
        ```

    - 将下列信息加入 `noetic-desktop_full.rosinstall` 文件：

        ```
        - tar:
            local-name: navigation_msgs/move_base_msgs
            uri: https://github.com/ros-gbp/navigation_msgs-release/archive/release/noetic/move_base_msgs/1.14.1-1.tar.gz
            version: navigation_msgs-release-release-noetic-move_base_msgs-1.14.1-1
        ```

    - 如果是方法三，则在此处继续向 `noetic-desktop_full.rosinstall` 文件添加其他包信息，例如 `ros-noetic-serial` 和 `catkin_virtualenv` 等包。

    - 将 `noetic-desktop_full.rosinstall` 文件另存为 `noetic-AgRobot.rosinstall` 并退出。

    需要注意的是，此方法仍然需要手动修改 `.rosinstall` 文件的内容，但相比前一种方法可靠性已大幅提高，修改过程也极为简单。而且 `.rosinstall` 文件可以被保存和分发，从而便于利用已经保存好的文件完整复刻出整个 ROS 环境。
