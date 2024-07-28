# we need to build wayvnc from source till Debian trixie is released, then we can use the package from there because of missing features
FROM debian:bookworm as wayvnc-build

RUN apt-get update && apt-get install -y build-essential git \
    meson libdrm-dev libxkbcommon-dev libwlroots-dev libjansson-dev \
    libpam0g-dev libgnutls28-dev libavfilter-dev libavcodec-dev \
    libavutil-dev libturbojpeg0-dev scdoc \
    sway lsof jq bash python3-pip
RUN pip install --break-system-packages vncdotool
RUN useradd -m user 
USER user
WORKDIR /home/user
RUN git -c advice.detachedHead=false clone -b v0.8.0 https://github.com/any1/wayvnc.git
RUN git -c advice.detachedHead=false clone -b v0.8.0 https://github.com/any1/neatvnc.git
RUN git -c advice.detachedHead=false clone -b v0.3.0 https://github.com/any1/aml.git
RUN mkdir wayvnc/subprojects && cd wayvnc/subprojects && ln -s ../../neatvnc . && ln -s ../../aml . 
RUN mkdir neatvnc/subprojects && cd neatvnc/subprojects && ln -s ../../aml .
WORKDIR /home/user/wayvnc
RUN meson build
RUN ninja -C build
RUN meson test -C build
RUN ./test/integration/integration.sh


FROM debian:bookworm as common

RUN apt-get update && apt-get install --no-install-recommends -y cage sway iproute2 \
    libaml0 libc6  libneatvnc0 libpam0g libpixman-1-0 libwayland-client0 libxkbcommon0 \
    libdrm2 libgbm1 libjansson4 \
    libwlroots10
COPY --from=wayvnc-build --chown=root:root /home/user/wayvnc/build/wayvnc /usr/local/bin/wayvnc


FROM common as build

RUN apt-get update && apt-get install -y build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.0-dev golang ca-certificates


WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN GOOS=linux go build -o /usr/local/bin/tellerrand

FROM build as dev


ENV WLR_BACKENDS=headless \
    WLR_LIBINPUT_NO_DEVICES=1 \
    WAYLAND_DISPLAY=wayland-1 \
    XDG_RUNTIME_DIR=/run/xdg
RUN mkdir /run/xdg

RUN useradd -m myuser && chown myuser /run/xdg
USER myuser
WORKDIR /home/myuser

# FROM common as prod

# COPY apt.prod.txt ./
# RUN apt-get install --no-install-recommends -y libgtk-3-0 libwebkit2gtk-4.0-37

# COPY --from=dev /usr/local/bin/tellerrand /usr/local/bin/tellerrand

