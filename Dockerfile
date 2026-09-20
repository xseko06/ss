ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_VERSION
ENV INSTALLED_VER=${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# 1. install neofetch, if failed -> fastfetch
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget curl git python3 python3-pip && \
    (apt-get install -y neofetch || apt-get install -y fastfetch) && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

RUN mkdir -p /root/workspace

# 2. check
RUN echo "echo 'Welcome to Ubuntu ${INSTALLED_VER} on Browser! 🐧'" >> /root/.bashrc && \
    echo "cd /root/workspace" >> /root/.bashrc && \
    echo "command -v neofetch >/dev/null 2>&1 && neofetch || fastfetch" >> /root/.bashrc

EXPOSE $PORT

CMD ["/bin/bash", "-c", "/bin/ttyd -p ${PORT:-8080} -c ${USERNAME:-admin}:${PASSWORD:-admin} /bin/bash"]
