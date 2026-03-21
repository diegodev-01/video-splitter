#!/usr/bin/env bash
trap 'echo "Stopping all receivers..."; kill $(jobs -p); exit' SIGINT

PORT=5000
X_POS=(0 426 852)
Y_POS=(100 100 100)

echo "Esperando flujos en el puerto $PORT..."

for i in {0..2}; do
    echo "Lanzando instancia de recepción $((i+1))..."

    gst-launch-1.0 -v \
        udpsrc port=$PORT caps="application/x-rtp,media=video,encoding-name=H264,payload=96" ! \
        rtpjitterbuffer mode=low-latency ! \
        rtph264depay ! \
        decodebin ! \
        videoconvert ! \
        autovideosink sync=false &
    
    PID=$!

    sleep 2
    
    WINDOW_ID=$(xdotool search --pid $PID | tail -n 1)
    if [ -n "$WINDOW_ID" ]; then
        xdotool windowmove "$WINDOW_ID" "${X_POS[$i]}" "${Y_POS[$i]}"
        echo "Ventana $((i+1)) posicionada en ${X_POS[$i]},${Y_POS[$i]}"
    else
        echo "Advertencia: No se encontró ventana para el proceso $PID"
    fi
done

wait