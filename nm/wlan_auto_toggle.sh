#!/usr/bin/env bash

if [[ $1 == en* ]]; then
    case "$2" in
        up)
            logger "[$0] ethernet connect detected: turning wlan OFF";
            nmcli radio wifi off
            ;;
        down)
            logger "[$0] ethernet disconnect detected: turning wlan ON";
            nmcli radio wifi on
            ;;
    esac
fi