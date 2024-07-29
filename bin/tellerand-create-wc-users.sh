#!/bin/sh

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <number_of_users>"
    exit 1
fi

num_users="$1"

for ((i = 1; i <= num_users; i++)); do
    useradd -m "wc${i}"
done
