# docker4openni2

Copy the rule into `/etc/udev/rules.d` and run the command:
```
  sudo udevadm trigger --action=change
```

## Networking containers across multiple hosts (in the same network)

Based on [the Docker docs](https://docs.docker.com/network/network-tutorial-overlay/#use-an-overlay-network-for-standalone-containers).

1. In external PC
```
docker swarm init
```
(keep the token step 2)

2. In TurtleBot
```
docker swarm join --token <TOKEN> <IP-ADDRESS-OF-MANAGER>:2377
```

3. In external PC
```
docker network create -d overlay --attachable rosnet
```

4. In TurtleBot
```
docker run --rm -it --net=rosnet --name turtlebot \
  --env ROS_HOSTNAME=turtlebot \
  --env ROS_MASTER_URI=http://turtlebot:11311 \
  --privileged -v /dev/bus/usb:/dev/bus/usb \
  openni2:kinetic roslaunch openni2_launch openni2.launch
```

5. In external PC
```
xhost +local:root
docker run --rm -it --net=rosnet --name client \
  --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" \
  --env ROS_HOSTNAME=client \
  --env ROS_MASTER_URI=http://turtlebot:11311 \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  osrf/ros:kinetic-desktop-full rosrun image_view image_view image:=/camera/rgb/image_raw
xhost -local:root
```
