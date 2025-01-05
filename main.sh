#!/usr/bin/bash

#Variable to hold Files
x="$(date | tr ' :,' '_')"

# Create Directory
mkdir -p "$x"

# Copy Needed Files
cp -r /var/lock "/home/micro/Desktop/Auto/$x"
cp -r /var/run "/home/micro/Desktop/Auto/$x"
cp -r /var/backups "/home/micro/Desktop/Auto/$x"

git add .

git commit -m "$x"

git push
