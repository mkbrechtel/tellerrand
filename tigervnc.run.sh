#!/bin/sh

export DISPLAY=:1
Xtigervnc $DISPLAY -desktop hi! -auth .Xauthority -geometry 1920x1200 -depth 24 -pn -SecurityTypes None &
i3 &

