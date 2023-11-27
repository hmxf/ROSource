# Build ROS from source

See install guide and scripts in `_BuildGuide` for details.

Currently, we just offer support for ROS noetic.

However it may offer some help for other versions as well.

## How to use this Repo

- Set temporary environment variables

    Here is an example:

    ```bash
    ROS_BUILD_PATH=~/ros
    ROS_INSTALL_PATH=~/ros/noetic
    ```

    - Point `$ROS_BUILD_PATH` to the compilation path of ROS.
    
        In the path `$ROS_BUILD_PATH/build/noetic` there are some `.rosinstall` files and a `src` folder that stores the ROS Noetic source code.
    
    - Point `$ROS_INSTALL_PATH` to the install path of ROS.
    
        The compiled and installed ROS Noetic is located in the path `$ROS_INSTALL_PATH`

- Create compilation path

    ```bash
    sudo mkdir $ROS_BUILD_PATH
    sudo chown -R $USER:$USER $ROS_BUILD_PATH
    ```
    
    Fetch this repo to `$ROS_BUILD_PATH`, rename it to `build` and switch into `$ROS_BUILD_PATH/build/noetic`

    ```bash
    cd $ROS_BUILD_PATH && git clone https://github.com/hmxf/ROSource build
    cd $ROS_BUILD_PATH/build/noetic
    ```

- For subsequent operations, please refer to the documentation under the `_BuildGuide` path.

    For example, since you are in `$ROS_BUILD_PATH/build/noetic` now and is ready to do something big, you can use scripts like this:

    ```bash
    ../_BuildGuide/1.prepare_sysenv.sh
    ../_BuildGuide/2.prepare_rosenv.sh
                   ...
    ```