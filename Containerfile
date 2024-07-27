FROM debian:bookworm as common

COPY apt.common.txt ./
RUN apt-get update && apt-get install --no-install-recommends -y $(grep -v '^#' apt.common.txt)


FROM common as dev

COPY apt.dev.txt ./
RUN apt-get install --no-install-recommends -y $(grep -v '^#' apt.dev.txt)

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN GOOS=linux go build -o /usr/local/bin/tellerrand

EXPOSE 8080
CMD tigervncserver -xstartup /usr/local/bin/tellerrand


# FROM common as prod

# COPY apt.prod.txt ./
# RUN apt-get install --no-install-recommends -y $(grep -v '^#' apt.prod.txt)

# COPY --from=dev /usr/local/bin/tellerrand /usr/local/bin/tellerrand

