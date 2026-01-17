#!/usr/bin/env bash
trap 'echo "Stopping all streams..."; kill $(jobs -p); exit' SIGINT

HOST="127.0.0.1"
VIDEO="$HOME/Videos/sample_video.mp4"
VIDEO_WIDTH=1280
VIDEO_HEIGHT=240

for ARG in "$@"; do
    case $ARG in
        host=*) HOST="${ARG#*=}" ;;
        video=*) VIDEO="${ARG#*=}" ;;
        width=*) VIDEO_WIDTH="${ARG#*=}" ;;
        height=*) VIDEO_HEIGHT="${ARG#*=}" ;;
        *) echo "Unknown argument: $ARG" ;;
    esac
done

echo "Using host=$HOST"
echo "Using video=$VIDEO"
echo "Video resolution: ${VIDEO_WIDTH}x${VIDEO_HEIGHT}"

declare -A BOX1=( [top]=0 [bottom]=0 [left]=0 [right]=426 [port]=5001 )
declare -A BOX2=( [top]=0 [bottom]=0 [left]=426 [right]=852 [port]=5002 )
declare -A BOX3=( [top]=0 [bottom]=0 [left]=852 [right]=1280 [port]=5003 )

BOXES=(BOX1 BOX2 BOX3)

for BOX_NAME in "${BOXES[@]}"; do
    declare -n BOX="$BOX_NAME"

    PORT="${BOX[port]}"
    TOP="${BOX[top]}"
    BOTTOM="${BOX[bottom]}"
    LEFT="${BOX[left]}"
    RIGHT="${BOX[right]}"

    TOP_CROP=$TOP
    BOTTOM_CROP=$BOTTOM
    LEFT_CROP=$LEFT
    RIGHT_CROP=$((VIDEO_WIDTH - RIGHT))

    echo "Starting stream for $BOX_NAME on port $PORT"

    gst-launch-1.0 -v \
        filesrc location="$VIDEO" ! \
        decodebin ! queue ! \
        videocrop top=$TOP_CROP left=$LEFT_CROP right=$RIGHT_CROP bottom=$BOTTOM_CROP ! \
        openh264enc bitrate=4000 ! \
        rtph264pay config-interval=1 pt=96 ! \
        udpsink host=$HOST port=$PORT &
done

wait
