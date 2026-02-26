

# docker build --network=host -t flclash:0.8.92 . 

xhost +local:docker && docker run --rm \
  --gpus all \
  -e NVIDIA_DISABLE_REQUIRE=1 \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e DISPLAY="$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$HOME/.config/FlClash:/root/.config/FlClash" \
  -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
  --net=host \
  flclash:0.8.92