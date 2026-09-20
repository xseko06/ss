FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget curl git python3 python3-pip nodejs npm neofetch vim nano htop build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget --tries=3 --timeout=30 -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /bin/ttyd

RUN echo "neofetch" >> /root/.bashrc && \
    echo "cd /root" >> /root/.bashrc

EXPOSE 8080

CMD ["/bin/bash", "-c", "\
    echo \"export PS1='\\[\\033[01;32m\\]${USERNAME:-user}@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '\" >> /root/.bashrc && \
    if [ -n \"$USERNAME\" ] && [ -n \"$PASSWORD\" ]; then \
        exec /bin/ttyd -p ${PORT:-8080} -W -c \"$USERNAME:$PASSWORD\" /bin/bash; \
    else \
        exec /bin/ttyd -p ${PORT:-8080} -W /bin/bash; \
    fi"]
