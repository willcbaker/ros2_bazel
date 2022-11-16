FROM osrf/ros:humble-desktop


# Install bazel
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  apt-transport-https \
  curl \
  gnupg

RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
RUN mv bazel-archive-keyring.gpg /usr/share/keyrings
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y bazel

# Add non-root user
ARG ROS_USER=ros
RUN groupadd -r ${ROS_USER} && useradd -m -r -g ${ROS_USER} ${ROS_USER}
USER ${ROS_USER}

# Copy the example workspace
COPY --chown=${ROS_USER}:${ROS_USER} src bazel_ws
WORKDIR bazel_ws

# Try building the
RUN bazel build @rules_ros//examples/bazel_simple_example:bazel_simple_example_pkg
