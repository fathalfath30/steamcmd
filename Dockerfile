# Use Alpine Linux as the base image
FROM ubuntu:22.04

ARG GROUP_ID=2300
ARG GROUP_NAME="steamcmd"

ARG USER_ID=2300
ARG USER_NAME="steamcmd"

ENV HOME_DIR=/home/${USER_NAME}/steam

# create new group and user account
# to handle the server using user and group arguments
RUN if ! grep -q "^$GROUP_NAME:" /etc/group; then \
        echo "Creating group '$GROUP_NAME' with GID '$GROUP_ID'" && \
        groupadd -g $GROUP_ID $GROUP_NAME; \
    else \
        echo "Group '$GROUP_NAME' already exists."; \
    fi && if ! id -u $USER_NAME &>/dev/null; then \
        echo "Creating user '$USER_NAME' with UID '$USER_ID' and adding to group '$GROUP_NAME'" && \
        useradd -m -u $USER_ID -g $GROUP_NAME $USER_NAME; \
        usermod -aG sudo $USER_NAME; \
    else \
        echo "User '$USER_NAME' already exists."; \
    fi

# updating alpine repository
RUN apt update && apt install -y software-properties-common
RUN add-apt-repository multiverse && dpkg --add-architecture i386 && apt update
RUN apt install -y bash curl wget tar zip lib32gcc-s1 ca-certificates locales sudo

# disable password when using sudo
RUN echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER_NAME}

# change to user and create directory to store steamcmd 
# using user defined above
RUN mkdir -p ${HOME_DIR}
WORKDIR ${HOME_DIR}

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | sudo debconf-set-selections \
 && echo steam steam/license note '' | sudo debconf-set-selections

# install steamcmd
RUN sudo apt install -y steamcmd

# Add unicode support
RUN sudo locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

# create symlink for executable
RUN sudo ln -s /usr/games/steamcmd /usr/bin/steamcmd

# update steamcmd and verify latest version
RUN steamcmd +quit

# fix missing steamcmd directories and libraries
RUN mkdir -p $HOME/.steam
RUN ln -sf $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
 && ln -sf $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
 && ln -sf $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
 && ln -sf $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

ENTRYPOINT ["steamcmd"]
CMD ["+help", "+quit"]