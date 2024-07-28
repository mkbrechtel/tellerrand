#!/bin/sh -e

echo building dev image
podman build --target dev --tag tellerrand-dev .
exec podman run -it --rm -p 5901:5901 -v ./:/app tellerrand-dev bash
