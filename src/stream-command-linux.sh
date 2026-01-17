gst-launch-1.0 -v filesrc location=/home/debianhack1/Downloads/video_test.mp4 ! decodebin ! queue ! videocrop top=0 left=0 right=426 bottom=0 ! openh264enc ! rtph264pay ! udpsink host=127.0.0.1 port=5001

gst-launch-1.0 -v udpsrc port=5001 caps"application/x-rtp, media=video, encoding-name=H264, payload=96" ! rtph264depay ! avdec_h264 ! autovideosink
