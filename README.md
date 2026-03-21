# Video Spliter Tool

It's a tool that allows a master PC to control multimedia across multiple PCs via a network. A single video is split into three parts, with each part sent to a separate screen.

## Requirements

- Gstreamer >= 1.26

### Verify On windows

``` powershell
gst-launch-1.0 --version

 gst-launch-1.0 version 1.26.10
 GStreamer 1.26.10
 Unknown package origin

```

### Verify On Linux

``` bash
gst-launch-1.0 --version

 gst-launch-1.0 version 1.26.10
 GStreamer 1.26.10
 Unknown package origin

```

#### Linux-instalation

``` bash
sudo apt install -y gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav
```

#### Windows-instalation

[Download from his page](https://gstreamer.freedesktop.org/download/?__goaway_challenge=meta-refresh&__goaway_id=917307d1c182d740d9b5f1ce5b5b0381&__goaway_referer=https%3A%2F%2Fgstreamer.freedesktop.org%2F#windows)

> It recommends adding the GStreamer bin folder to the system PATH so that gst-launch-1.0 can be run from any terminal

## How to use

### Host

1. Have to give the excecution permissions to main script

    ``` bash
        chmod +x /path/to/your/video
    ```

2. Run the 'main.sh' script with these inline parameters

    ``` bash
        ./main.sh host=ip-from-host video=/path/to/your/video # optional resolution width=1280 height=240
        # For example
        ./main.sh host=127.0.0.1 video=/home/diego/Downloads/video_test.mp4 width=1280 height=240
    ```

    > By default, the ports used are 5001, 5002, and 5003.

### Client

1. Run the 'receiver.sh'.

2. If you want to test the script without the script, you can use this

``` bash
    gst-launch-1.0 -v udpsrc port=5001 caps="application/x-rtp,media=video,encoding-name=H264,payload=96" ! rtph264depay ! avdec_h264 ! videoconvert ! autovideosink sync=false
```
