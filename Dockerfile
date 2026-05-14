FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    firefox \
    dbus-x11 x11-utils \
    curl wget git vim \
    && apt clean

RUN mkdir ~/.vnc
RUN echo "123456" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

EXPOSE 6080

CMD bash -c "\
vncserver :1 -geometry 1280x720 -localhost no && \
websockify --web=/usr/share/novnc/ 6080 localhost:5901"
