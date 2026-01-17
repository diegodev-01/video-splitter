#!/usr/bin/env bash
trap 'echo "Stopping all receivers..."; kill $(jobs -p); exit' SIGINT

PORTS=(5001 5002 5003)
X_POS=(1000 1100 1200)
Y_POS=(100 100 100)

for i in "${!PORTS[@]}"; do
    PORT="${PORTS[$i]}"
    gst-launch-1.0 -v \
        udpsrc port=$PORT caps="application/x-rtp, media=video, encoding-name=H264, payload=96" ! \
        rtph264depay ! avdec_h264 ! autovideosink &
    
    PID=$!
    
    sleep 2
    
    WINDOW_ID=$(xdotool search --pid $PID | head -n 1)
    xdotool windowmove $WINDOW_ID ${X_POS[$i]} ${Y_POS[$i]}
done

wait
