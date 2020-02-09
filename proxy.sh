#!/usr/bin/env bash

declare -A PROXIES
PROXIES["Etablissement"]="http://192.168.228.254:3128"

_ssid="$(nmcli -c no -t -f name connection show --active)"
_proxy="${PROXIES["$_ssid"]}"

export_proxy() {
    export http_proxy="$_proxy"
    export https_proxy="$_proxy"
}

if [ "$#" -gt 1 ]; then
    http_proxy="$_proxy" https_proxy="$_proxy" "$@"
fi
