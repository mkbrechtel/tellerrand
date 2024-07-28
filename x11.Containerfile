FROM debian:bookworm as common

RUN apt-get update && apt-get install --no-install-recommends -y sway wayvnc


FROM common as build

RUN apt-get update && apt-get install -y build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.0-dev golang ca-certificates


WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN GOOS=linux go build -o /usr/local/bin/tellerrand

FROM build as dev

RUN wayland.Containerfile

#RUN useradd -m myuser && chown myuser /run/xdg
#USER myuser
#WORKDIR /home/myuser

# FROM common as prod

# COPY apt.prod.txt ./
# RUN apt-get install --no-install-recommends -y libgtk-3-0 libwebkit2gtk-4.0-37

# COPY --from=dev /usr/local/bin/tellerrand /usr/local/bin/tellerrand

