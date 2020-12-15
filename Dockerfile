FROM ros:kinetic-ros-base

RUN apt-get update && apt-get install -y \
    ros-kinetic-openni2-camera ros-kinetic-openni2-launch \
    && rm -rf /var/lib/apt/lists/*

CMD ["roslaunch", "openni2_launch", "openni2.launch"]
