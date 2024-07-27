FROM debian:bookworm

COPY apt.txt ./
RUN apt-get update && apt-get install --no-install-recommends -y $(grep -v '^#' apt.txt)
