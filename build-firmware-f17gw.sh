#!/bin/bash
set -xe

# f17gw
VERSION=18.06.1
PLATFORM=ar71xx
TYPE=generic
PROFILE=tl-wdr4300-v1
PACKAGES="luci-app-firewall luci-app-wireguard luci-proto-wireguard wireguard-tools prometheus-node-exporter-lua ddns-scripts luci-app-ddns -dnsmasq dnsmasq-full luci-proto-ipv6 tcpdump-mini curl ip-full uhttpd luci-mod-admin-full luci-theme-bootstrap libiwinfo-lua -wpa-supplicant -wpa-supplicant-mini -wpad-mini wpad -hostapd -hostapd-common -odhcpd-ipv6only curl ca-certificates libustream-openssl watchcat luci-app-watchcat"

#if [ "${VERSION}" = "snapshot" ] 
#  then wget -O /tmp/imagebuilder.tar.xz https://downloads.openwrt.org/snapshots/targets/${PLATFORM}/${TYPE}/openwrt-imagebuilder-${PLATFORM}-${TYPE}.Linux-x86_64.tar.xz
#else 
wget -O /tmp/imagebuilder.tar.xz https://downloads.openwrt.org/releases/${VERSION}/targets/${PLATFORM}/${TYPE}/lede-imagebuilder-${VERSION}-${PLATFORM}-${TYPE}.Linux-x86_64.tar.xz
tar -xJf /tmp/imagebuilder.tar.xz -C /tmp/imagebuilder/${VERSION}-${PLATFORM}-${TYPE} --strip-components=1

cd /tmp/imagebuilder/-${VERSION}-${PLATFORM}-${TYPE}

make image PROFILE=tl-wdr4300-v1 PACKAGES=$PACKAGES

#         bin/targets/ar71xx/generic/openwrt-18.06.1-ar71xx-generic-tl-wdr4300-v1-squashfs-sysupgrade.bin root@10.7.10.1:/tmp

echo "scp bin/targets/ar71xx/generic/openwrt-${VERSION}-${PLATFORM}-${type}-tl-wdr4300-v1-squashfs-sysupgrade.bin root@10.7.10.1:/tmp"
