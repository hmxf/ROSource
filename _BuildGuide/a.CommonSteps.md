# 公共步骤

以下包含一些在编译安装任何版本 ROS 时都需要首先完成的步骤。

## 预配置系统环境

- 将默认 `ubuntu-ports` 源替换为清华源

    ```bash
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo vi /etc/apt/sources.list
    ```

    将以下信息写入 `/etc/apt/sources.list` 后保存退出

    ```
    # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-updates main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-updates main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-backports main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-backports main restricted universe multiverse

    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-security main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-security main restricted universe multiverse

    # 预发布软件源，不建议启用
    # deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-proposed main restricted universe multiverse
    # # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ focal-proposed main restricted universe multiverse
    ```

- 更新系统、安装常用工具

    ```bash
    sudo apt update && sudo apt update && sudo apt upgrade && sudo apt autoremove
    sudo apt install nano git zsh curl wget tree htop tmux screen can-utils net-tools openssh-server python3-pip
    ```

## 预配置 ROS 编译环境

- 设置软件源

    ```bash
    sudo sh -c 'echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    sudo apt update
    ```

- 准备安装环境

    ```bash
    sudo apt install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential python3-catkin-tools libgoogle-glog-dev hugin-tools enblend glibc-doc
    sudo mkdir -p /etc/ros/rosdep/sources.list.d/
    sudo curl -o /etc/ros/rosdep/sources.list.d/20-default.list https://mirrors.tuna.tsinghua.edu.cn/github-raw/ros/rosdistro/master/rosdep/sources.list.d/20-default.list
    export ROSDISTRO_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/rosdistro/index-v4.yaml
    echo 'export ROSDISTRO_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/rosdistro/index-v4.yaml' >> ~/.bashrc
    rosdep update
    ```
