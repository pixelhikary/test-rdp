FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xrdp \
    xfce4 \
    xfce4-goodies \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 \
    firefox-esr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "root:root" | chpasswd

RUN if [ -f /etc/X11/Xwrapper.config ]; then \
        sed -i 's/^allowed_users=.*/allowed_users=anybody/' /etc/X11/Xwrapper.config; \
    else \
        echo "allowed_users=anybody" > /etc/X11/Xwrapper.config; \
    fi

RUN echo "startxfce4" > /root/.xsession && \
    chmod 700 /root/.xsession

RUN mkdir -p /var/run/dbus /var/lib/dbus && \
    dbus-uuidgen > /etc/machine-id && \
    ln -sf /etc/machine-id /var/lib/dbus/machine-id

RUN sed -i 's/^crypt_level=.*/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/^security_layer=.*/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    printf '#!/bin/sh\nexec startxfce4\n' > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

RUN adduser xrdp ssl-cert

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
