FROM debian:bookworm as common

RUN apt-get update && apt-get install --no-install-recommends -y i3 tigervnc-standalone-server tigervnc-tools


FROM common as build-webview

RUN apt-get update && apt-get install -y build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.0-dev golang ca-certificates

WORKDIR /app/webview
COPY webview/go.mod webview/go.sum ./
RUN go mod download
COPY webview/*.go ./
RUN GOOS=linux go build -o /usr/local/bin/tellerrand-webview
WORKDIR /app


FROM build-webview as dev

ENV PATH=/mnt/bin:$PATH
#RUN useradd -m myuser && chown myuser /run/xdg
#USER myuser
#WORKDIR /home/myuser


FROM common as prod

RUN apt-get install --no-install-recommends -y libgtk-3-0 libwebkit2gtk-4.0-37

COPY --chown=root:root ./i3/ /etc/i3/
COPY --from=build-webview /usr/local/bin/tellerrand-webvie /usr/local/bin/tellerrand-webvie
