#!/bin/sh

## CCreate Virtual Display
Xvfb :1 -nocursor -screen 0 1024x768x24 </dev/null &
export DISPLAY=":1"

## Start video Stream
avconv -codec:a libvorbis -f x11grab -s 1024x768 -i :1  -f flv rtmp://127.0.0.1/live &

## Run Sketch
/processing-3.5.3/processing-java --sketch=/sketch --run &


