#!/bin/bash

# Mikrotik seems to prefer bootp
# Best instructions for installing OpenWRT onto a Microtic Hex-S:
# https://www.radiusdesk.com/docuwiki/user_guide/mikrotik/openwrt_rb750gr3

USER=root
IFNAME=enx48d705e9d307
FILENAME=kernel.bin
/sbin/ip addr replace 192.168.1.10/24 dev $IFNAME
/sbin/ip link set dev $IFNAME up
/usr/sbin/dnsmasq --user=$USER \
--no-daemon \
--listen-address 192.168.1.10 \
--bind-interfaces \
-p0 \
--dhcp-authoritative \
--dhcp-range=192.168.1.100,192.168.1.200 \
--bootp-dynamic \
--dhcp-boot=$FILENAME \
--log-dhcp \
--enable-tftp \
--tftp-root=/home/simon/Downloads \
--tftp-no-blocksize
