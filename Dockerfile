FROM debian:13

# Fallback for local Docker; Railway will override this
ENV PORT=7681
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     ca-certificates wget curl git python3 python3-pip tini fastfetch

# Install latest ttyd (auto-updating)
RUN wget -qO /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
  && chmod +x /usr/local/bin/ttyd

# Show system info on shell start (fastfetch)
RUN echo "fastfetch || true" >> /root/.bashrc

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini","--"]

CMD ["/bin/bash","-lc","/usr/local/bin/ttyd --writable -i 0.0.0.0 -p ${PORT} -c ${USERNAME}:${PASSWORD} /bin/bash"]
