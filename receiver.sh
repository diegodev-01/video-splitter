trap 'echo "Stopping receiver..."; kill $(jobs -p); exit' SIGINT

PORT=5001 

echo "--- Iniciando Recepción de Video Wall (Modo Raw) ---"

INTERFACE=$(ip -o link show | awk -F': ' '$2 != "lo" {print $2}' | head -n 1)
MY_IP=$(ip -4 addr show "$INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

echo "Interfaz: $INTERFACE | IP: $MY_IP | Puerto: $PORT"

gst-launch-1.0 -v \
    udpsrc port=$PORT caps="application/x-rtp,media=video,encoding-name=H264,payload=96" ! \
    rtpjitterbuffer mode=low-latency ! \
    rtph264depay ! \
    avdec_h264 ! \
    videoconvert ! \
    kmssink sync=false force-aspect-ratio=false