#!/bin/bash

HEADPHONES="alsa_output.usb-MV-SILICON_fifine_AM8_Pro_20190808-00.analog-stereo"
SPEAKERS="alsa_output.pci-0000_0f_00.6.analog-stereo"

get_current_sink() {
    pactl get-default-sink
}

get_current_volume() {
    pactl get-sink-volume $(get_current_sink) | awk '{print $5}' | sed 's/%//'
}

show_icon() {
    current=$(get_current_sink)

    if [[ "$current" == *"$HEADPHONES"* ]]; then
        echo '{"text": "󰋋", "alt": "HEADPHONESs", "class": "hdmi", "tooltip": "Наушники"}'
    elif [[ "$current" == *"$SPEAKERS"* ]]; then
        echo '{"text": "󰓃", "alt": "speakers", "class": "analog", "tooltip": "Динамики"}'
    else
        # Если какое-то другое устройство
        echo '{"text": "🔈", "alt": "unknown", "class": "unknown", "tooltip": "Другое устройство"}'
    fi
}

# Функция переключения устройств
switch_audio() {
    current=$(get_current_sink)

    if [[ "$current" == *"$HEADPHONES"* ]]; then
        new_sink="$SPEAKERS"
    else
        new_sink="$HEADPHONES"
    fi

    # Переключаем устройство по умолчанию
    pactl set-default-sink "$new_sink"

    # Переключаем все текущие стримы на новое устройство
    pactl list short sink-inputs | while read stream; do
        streamId=$(echo $stream | cut '-d ' -f1)
        pactl move-sink-input "$streamId" "$new_sink"
    done

    show_icon
}

# Основная логика
case "$1" in
    "icon")
        show_icon
        ;;
    "switch")
        switch_audio
        ;;
    *)
        echo "Использование: $0 {icon|switch}"
        exit 1
        ;;
esac
