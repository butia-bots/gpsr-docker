FROM ros:noetic

WORKDIR /butia_ws

COPY ./requirements.txt ./requirements.txt
RUN apt update && apt install -y python3-pip && xargs -n 1 -a requirements.txt pip install; exit 0


RUN apt update && apt install -y ros-noetic-smach ros-noetic-robot-state-publisher ros-noetic-joint-state-publisher ros-noetic-navigation ros-noetic-moveit-visual-tools ros-noetic-moveit ros-noetic-ros-controllers ros-noetic-effort-controllers ros-noetic-gmapping ros-noetic-eigen-conversions ros-noetic-tf-conversions ros-noetic-vision-msgs ros-noetic-dynamixel-sdk python3-catkin-tools python3-wstool git

#RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
#WORKDIR /butia_ws/openpose/build
#RUN cmake .. && make && make install

WORKDIR /butia_ws
COPY .rosinstall .rosinstall

RUN apt install -y openssh-client

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
#RUN --mount=type=ssh git clone -v git@github.com:butia-bots/butia_behavior.git src/butia_behavior


ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=ssh . /opt/ros/noetic/setup.sh && wstool update; exit 0
RUN rm -rf src/butia_vision/butia_vision_msgs
RUN rm -rf src/interbotix_**/**/CATKIN_IGNORE
RUN . /opt/ros/noetic/setup.sh && rosdep install --from-paths src --ignore-src -y -r && catkin build