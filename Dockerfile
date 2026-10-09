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

# 3. 'Platen' kullanıcısını oluşturuyoruz ve sudo yetkisi veriyoruz
RUN useradd -ms /bin/bash Platen && \
    echo "Platen:erbaa2023_" | chpasswd && \
    usermod -aG sudo Platen

WORKDIR /home/Platen
RUN chown -R Platen:Platen /home/Platen

# Railway'in kullanacağı portu dışarıya açıyoruz
EXPOSE 7681

# Terminal ilk açıldığında ekranı temizleyip gökkuşağı (rainbow) renkli ASCII Art'ı göstermesi için .bashrc'yi ayarlıyoruz
RUN echo 'clear' > /home/Platen/.bashrc && \
    echo 'echo -e "\033[31m░▒▓███████▓▒░░▒▓█▓▒░       ░▒▓██████▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓███████▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[33m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[32m░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[36m░▒▓███████▓▒░░▒▓█▓▒░      ░▒▓████████▓▒░ ░▒▓█▓▒░    ░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[34m░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[35m░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo -e "\033[91m░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░    ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░\033[0m"' >> /home/Platen/.bashrc && \
    echo 'echo ""' >> /home/Platen/.bashrc && \
    echo 'echo "Railway Ubuntu Cloud ortamına hoş geldiniz!"' >> /home/Platen/.bashrc && \
    echo 'echo ""' >> /home/Platen/.bashrc
RUN chown Platen:Platen /home/Platen/.bashrc

# 4. ttyd için kimlik doğrulama ve başlatma betiği
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'PASS="erbaa2023_"' >> /entrypoint.sh && \
    echo 'echo "Platen:$PASS" | chpasswd' >> /entrypoint.sh && \
    echo 'chown -R Platen:Platen /home/Platen' >> /entrypoint.sh && \
    echo 'exec su - Platen -c "ttyd --port ${PORT:-7681} --writable --credential \"Platen:$PASS\" -t titleFixed=\"Platen Ubuntu Cloud\" tmux new-session -A -s main"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Konteyner ayağa kalkarken betiği çalıştırıyoruz
CMD ["/entrypoint.sh"]
