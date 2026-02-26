FROM registry.mipmap3d.com/docker/nvidia/cuda:12.8.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    HTTP_PROXY=http://127.0.0.1:7890 \
    HTTPS_PROXY=http://127.0.0.1:7890 \
    http_proxy=http://127.0.0.1:7890 \
    https_proxy=http://127.0.0.1:7890 \
    NO_PROXY=localhost,127.0.0.1 \
    no_proxy=localhost,127.0.0.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libasound2 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libdbus-1-3 \
        libdrm2 \
        libexpat1 \
        libgbm1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libx11-6 \
        libx11-xcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxkbcommon0 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        libgl1 \
        libegl1 \
        libcanberra-gtk3-module \
        libfuse2 \
        dbus-x11 \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/flclash

COPY FlClash.AppImage /opt/flclash/FlClash.AppImage

RUN chmod +x /opt/flclash/FlClash.AppImage \
    && /opt/flclash/FlClash.AppImage --appimage-extract \
    && mv /opt/flclash/squashfs-root /opt/flclash/app \
    && rm /opt/flclash/FlClash.AppImage

# 注入 XInitThreads 库，解决 Flutter 多线程 X11 崩溃
COPY xthreads_init.so /usr/local/lib/xthreads_init.so
RUN ldconfig

# 中文字体（从宿主机复制，避免 apt 安装大包）
COPY NotoSansCJK-Regular.ttc /usr/share/fonts/opentype/NotoSansCJK-Regular.ttc
RUN fc-cache -f

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
