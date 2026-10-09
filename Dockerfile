# Temel olarak en kararlı ve güncel Ubuntu sürümünü kullanıyoruz
FROM ubuntu:24.04

# Kurulum sırasında terminalin soru sormasını engeller
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 1. Temel sistem araçlarını ve kodlama kütüphanelerini kuruyoruz
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    nano \
    vim \
    tmux \
    sudo \
    ca-certificates \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# 2. Tarayıcıdan terminale bağlanmak için 'ttyd' aracını indiriyoruz
RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# 3. Mevcut 'ubuntu' kullanıcısını yapılandırıyoruz (zaten var olduğu için hata vermez)
RUN id -u ubuntu &>/dev/null || useradd -ms /bin/bash ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

WORKDIR /home/ubuntu
RUN chown -R ubuntu:ubuntu /home/ubuntu

# Railway'in kullanacağı portu dışarıya açıyoruz
EXPOSE 7681

# Terminal ilk açıldığında ekranı temizleyip (clear) en üstte ASCII Art'ı göstermesi için .bashrc'yi ayarlıyoruz
RUN echo 'clear' > /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;37m             \033[0;34m▄▄▄\033[0;34;47m▀▀▀\033[0;34m█\033[0;37m                 \033[0;34m▄▄▄\033[0;34;47m▀▀▀\033[0;34m█\033[0;37m                             \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;37m               \033[0;34m█\033[0;34;47m    \033[0;34m█\033[0;37m                   \033[0;34m█\033[0;34;47m    \033[0;34m█\033[0;37m                                   \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;37m  \033[0;30;44m▀\033[0;37;44m▄▄▄▄▄▄▄\033[0;30;44m▀\033[0;37m     \033[0;34m█\033[0;34;47m ░ \033[0;34m█\033[0;37m    \033[0;34m▄\033[0;34;47m▀▀\033[0;37m▒▀▀▄\033[0;34m█\033[0;37;44m▄▄\033[0;34m▄▄▄\033[0;37m  \033[0;34m█\033[0;34;47m ░ \033[0;34m█▄\033[0;37;44m▄\033[0;34m▄\033[0;37m     \033[0;34m▄\033[0;34;47m▀▀\033[0;37;44m█▀▀█\033[0;34;47m▀\033[0;37;44m▄\033[0;37m▄\033[0;37m      \033[0;30;44m▀\033[0;37;44m▄▄▄▄▄▄▄\033[0;30;44m▀\033[0;37m  \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;37m \033[0;34m█\033[0;37;44m█▓█\033[0;34m█▀█\033[0;37;44m█▓█\033[0;34m█\033[0;37m    \033[0;34m█\033[0;34;47m░▒░\033[0;34m█\033[0;37m    \033[0;34m█\033[0;34;47m ░ \033[0;34m█\033[0;37m    ░\033[0;37;44m█▓█\033[0;34m█\033[0;37m    \033[0;34m█\033[0;34;47m░▒░\033[0;37;44m▀▓█▀\033[0;34m▀\033[0;37m  \033[0;34m█\033[0;34;47m ░\033[0;37;44m▒\033[0;34m█\033[0;37m  \033[0;37;44m▒█▓█\033[0;35;44m░\033[0;37m    \033[0;34m█\033[0;37;44m█▓█\033[0;34m█▀█\033[0;37;44m█▓█\033[0;34m█\033[0;37m \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m▓▒▓     \033[0;37;44m ▓▒▓\033[0;34m█\033[0;37m  \033[0;34m█\033[0;34;47m▒▓▒\033[0;34m█\033[0;37m  \033[0;34m█\033[0;34;47m░▒░\033[0;34m█\033[0;37m     \033[0;34m█\033[0;37;44m▓▒▓\033[0;34m█\033[0;37m    \033[0;34m█\033[0;34;47m▒▓▒\033[0;34m██\033[0;37;44m░\033[0;34m█\033[0;37m  \033[0;34m█\033[0;34;47m▒░▒\033[0;37;44m░\033[0;37m    \033[0;37;44m░▓▀▀\033[0;34m▀\033[0;37m  \033[0;34m█\033[0;37;44m▓▒▓     \033[0;37;44m ▓▒▓\033[0;34m█\033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m▒░▒\033[0;34m▓   \033[0;34m▓\033[0;37;44m▒░▒\033[0;34m█\033[0;37m  \033[0;34m█\033[0;34;47m▓█▓\033[0;35;44m░\033[0;37m  \033[0;34m█\033[0;34;47m▒▓▒\033[0;34m█\033[0;37m     \033[0;34m█\033[0;37;44m▒░▒\033[0;35;44m░\033[0;37m    \033[0;34m█\033[0;34;47m▓█▓\033[0;35;44m░\033[0;34m▒▀\033[0;37m    \033[0;34m█\033[0;34;47m▒▓▒\033[0;34m█▀■▀▀▀\033[0;37m     \033[0;34m█\033[0;37;44m▒░▒\033[0;34m▓   \033[0;34m▓\033[0;37;44m▒░▒\033[0;34m█\033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m░ ░\033[0;34m▓   \033[0;34m▓\033[0;37;44m░ ░\033[0;34m█\033[0;37m  \033[0;34m█\033[0;34;44m \033[0;94;44m░ \033[0;35;44m▒\033[0;37m  \033[0;34m█\033[0;34;47m▓█▓\033[0;34m█\033[0;37m     \033[0;34m█\033[0;37;44m░ ░\033[0;35;44m▒\033[0;37m    \033[0;34m█\033[0;34;44m \033[0;94;44m░ \033[0;35;44m▒\033[0;34m░\033[0;37m     \033[0;34m█\033[0;34;47m▓█▓\033[0;35;44m░\033[0;37m     \033[0;34m▄▄■▄\033[0;37m  \033[0;34m█\033[0;37;44m░ ░\033[0;34m▓   \033[0;34m▓\033[0;37;44m░ ░\033[0;34m█\033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m██\033[0;34;44m \033[0;94;44m░▒ \033[0;34m▄\033[0;94;44m ▒░\033[0;34;44m \033[0;34m█\033[0;37m    \033[0;34m█\033[0;94;44m░▒░\033[0;35;44m▓\033[0;37m    \033[0;34m█\033[0;94;44m░▒░ \033[0;34m▄\033[0;37m \033[0;35m▄\033[0;34m█\033[0;34;44m \033[0;94;44m░ \033[0;35;44m▓\033[0;37m    \033[0;34m█\033[0;94;44m░▒░\033[0;35;44m▓\033[0;34m▓\033[0;35;44m▄■▄\033[0;37m  \033[0;34m█\033[0;34;44m \033[0;94;44m░\033[0;35;44m▒\033[0;34m▄\033[0;37m \033[0;34m▄\033[0;94;44m▒░░▒\033[0;35;44m▓\033[0;35m▌\033[0;37m \033[0;34m██\033[0;34;44m \033[0;94;44m░░    \033[0;94;44m░░\033[0;34;44m \033[0;34m██\033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m░\033[0;34m█\033[0;37;44m░\033[0;35;44m■▄\033[0;35m■\033[0;35;44m▄▄▄\033[0;35m▀\033[0;37m     \033[0;34m█\033[0;34;45m▀▀▀     \033[0;34m▀\033[0;35m▀▀▀▀\033[0;37m  \033[0;35m▀■\033[0;35;44m▄\033[0;35m█▄\033[0;37m  \033[0;35;44m■\033[0;34;45m▀▀▀\033[0;35;44m▄▀\033[0;34m▀▀▀\033[0;37m     \033[0;35m▀\033[0;35;44m▄▄▄▄\033[0;35m▀▀▀▀\033[0;37m    \033[0;35;44m▄▄\033[0;35m▀\033[0;35;44m▄▄    \033[0;35;44m▄▄\033[0;35m▀\033[0;35;44m▄▄\033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m▒\033[0;34m█\033[0;37;44m▒\033[0;34m█         \033[0;34m▀▀                     \033[0;34m▀▀                                       \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m█\033[0;37;44m▓▄▓\033[0;34m█                                                                                \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo -e "\033[0;34m▀▀▀▀▀                                                                                \033[0m"' >> /home/ubuntu/.bashrc && \
    echo 'echo ""' >> /home/ubuntu/.bashrc && \
    echo 'echo "Railway Ubuntu Cloud ortamına hoş geldiniz!"' >> /home/ubuntu/.bashrc && \
    echo 'echo ""' >> /home/ubuntu/.bashrc

# 4. Railway'den şifre gelmezse otomatik şifre atayan başlangıç betiği
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'PASS="${BOX_PASSWORD:-erbaa2023_}"' >> /entrypoint.sh && \
    echo 'echo "Platen:$PASS" | chpasswd' >> /entrypoint.sh && \
    echo 'exec ttyd --port ${PORT:-7681} --writable --credential "ubuntu:$PASS" -t titleFixed="P L A T E N S E R V E R" tmux new-session -A -s main' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Konteyner ayağa kalkarken betiği çalıştırıyoruz
CMD ["/entrypoint.sh"]
