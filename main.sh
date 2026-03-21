#!/usr/bin/env bash
trap 'echo "Stopping all streams..."; kill $(jobs -p); exit' SIGINT

PORT=5000
VIDEO="$HOME/Videos/sample_video.mp4"
VIDEO_WIDTH=1280
VIDEO_HEIGHT=240

for ARG in "$@"; do
    case $ARG in
        video=*) VIDEO="${ARG#*=}" ;;
        width=*) VIDEO_WIDTH="${ARG#*=}" ;;
        height=*) VIDEO_HEIGHT="${ARG#*=}" ;;
        port=*)  PORT="${ARG#*=}" ;;
        *) echo "Unknown argument: $ARG" ;;
    esac
done

echo "Streaming video: $VIDEO (${VIDEO_WIDTH}x${VIDEO_HEIGHT}) on Port: $PORT"

declare -A BOX1=( [top]=0 [bottom]=0 [left]=0   [right]=426  [ip]="192.168.0.100" )
declare -A BOX2=( [top]=0 [bottom]=0 [left]=426 [right]=852  [ip]="192.168.0.101" )
declare -A BOX3=( [top]=0 [bottom]=0 [left]=852 [right]=1280 [ip]="192.168.0.102" )

BOXES=(BOX1 BOX2 BOX3)

for BOX_NAME in "${BOXES[@]}"; do
    declare -n BOX="$BOX_NAME"

    DEST_IP="${BOX[ip]}"
    LEFT_CROP="${BOX[left]}"
    RIGHT_CROP=$((VIDEO_WIDTH - ${BOX[right]}))
    TOP_CROP="${BOX[top]}"
    BOTTOM_CROP="${BOX[bottom]}"

    echo "Starting stream for $BOX_NAME -> IP: $DEST_IP:$PORT"

    gst-launch-1.0 -v \
        filesrc location="$VIDEO" ! \
        decodebin ! queue ! \
        videocrop top=$TOP_CROP left=$LEFT_CROP right=$RIGHT_CROP bottom=$BOTTOM_CROP ! \
        videoconvert ! \
        openh264enc bitrate=4000 ! \
        rtph264pay config-interval=1 pt=96 ! \
        udpsink host=$DEST_IP port=$PORT &
done

wait