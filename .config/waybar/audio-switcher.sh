#!/bin/bash

HDMI_DEVICE="alsa_output.pci-0000_01_00.1.hdmi-stereo"
ANALOG_DEVICE="alsa_output.pci-0000_0f_00.6.analog-stereo"

get_current_sink() {
    pactl get-default-sink
}

get_current_volume() {
    pactl get-sink-volume $(get_current_sink) | awk '{print $5}' | sed 's/%//'
}

show_icon() {
    current=$(get_current_sink)

    if [[ "$current" == *"$HDMI_DEVICE"* ]]; then
        echo '{"text": "󰋋", "alt": "hdmi", "class": "hdmi", "tooltip": "Наушники (HDMI)"}'
    elif [[ "$current" == *"$ANALOG_DEVICE"* ]]; then
        echo '{"text": "󰓃", "alt": "analog", "class": "analog", "tooltip": "Динамики (Analog)"}'
    else
        # Если какое-то другое устройство
        echo '{"text": "🔈", "alt": "unknown", "class": "unknown", "tooltip": "Другое устройство"}'
    fi
}

# Функция переключения устройств
switch_audio() {
    current=$(get_current_sink)

    if [[ "$current" == *"$HDMI_DEVICE"* ]]; then
        new_sink="$ANALOG_DEVICE"
    else
        new_sink="$HDMI_DEVICE"
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
