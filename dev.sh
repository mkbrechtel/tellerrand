#!/bin/sh -e

echo building dev image
podman build --target dev --tag tellerrand-dev .
exec podman run -it --rm -p 5901:5901 -p 8080:8080 -v ./:/app -v ./i3/:/etc/i3/ tellerrand-dev bash
