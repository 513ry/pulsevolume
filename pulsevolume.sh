#!/usr/bin/bash

CACHE_DIR=~/.cache/pulsevolume

# Crate cache directory if needed
mkdir -p $CACHE_DIR

# Calculate how many seconds until next point divisible by 5
declare -ir sec=$(date +%S)
wait_time=$((5 - sec % 5))
wait_ms=$((wait_time * 1000 - 20))
if ((wait_ms > 0)); then
  sleep $(echo "scale=3; $wait_ms / 1000" | bc)
fi

while true; do
  pa_default_sink=$(pactl get-default-sink)
  [[ $(pactl get-sink-mute $pa_default_sink) = "Mute: yes" ]] && declare -l pa_sink_mute=true || declare -l pa_sink_mute=false

  if [[ "$pa_default_sink" =~ ^alsa_output ]]; then
    [ $pa_sink_mute = true ] && pa_sink_gliph="󰓄" || pa_sink_gliph="󰓃"
  elif [[ "$pa_default_sink" =~ ^bluez_output ]]; then
    [ $pa_sink_mute = true ] && pa_sink_gliph="󰂲" || pa_sink_gliph="󰂯"
  else
    [ $pa_sink_mute = true ] && pa_sink_gliph=X || pa_sink_gliph=?
  fi
  echo "$pa_sink_gliph $(pactl get-sink-volume $pa_default_sink | grep -Eo '[0-9][0-9]?[0-9]?%' | head -n 1)" >$CACHE_DIR/data
  sleep 5
done
