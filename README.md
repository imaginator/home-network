# Home Network

This is the code that configures my home network. The network consists of the following gear:
- (Ubiquiti EdgerouterX)[https://openwrt.org/toh/ubiquiti/ubiquiti_edgerouter_x_er-x_ka] (config)[edgerouter.settings]
- 3x (Ubiquiti Nanostation M2 Locos)[https://wiki.openwrt.org/toh/ubiquiti/nanostationm2] (config)[nanostationm2.settings]
- 1x (Ubiquiti AP Pro)[https://openwrt.org/toh/ubiquiti/unifi_appro] (config)[nanostationm2.settings]

The network is monitored at: https://bunker.imaginator.com/grafana/dashboard/db/wifi using the (Prometheus Node Exporter)[https://github.com/openwrt/packages/tree/master/utils/prometheus-node-exporter-lua].

## Subnetting

From `10.7.8.0/21` we have `10.7.8.0` - `10.7.15.255` (2046 IPs)

| Use                | Subnet address | Netmask       | Range of addresses      | Useable IPs             | Hosts |
| ------------------ | -------------- | ------------- | ----------------------- | ----------------------- | ----- |
| VPN termination    | 10.7.8.0/24    | 255.255.255.0 | 10.7.8.0 -  10.7.8.255  | 10.7.8.1 -  10.7.8.254  | 254   |
| IoT                | 10.7.9.0/24    | 255.255.255.0 | 10.7.9.0 -  10.7.9.255  | 10.7.9.1 -  10.7.9.254  | 254   |
| F17 Trusted        | 10.7.10.0/24   | 255.255.255.0 | 10.7.10.0 - 10.7.10.255 | 10.7.10.1 - 10.7.10.254 | 254   |
| W16A Trusted       | 10.7.11.0/24   | 255.255.255.0 | 10.7.11.0 - 10.7.11.255 | 10.7.11.1 - 10.7.11.254 | 254   |
| Notrust / Freifunk | 10.7.12.0/22   | 255.255.252.0 | 10.7.12.0 - 10.7.15.255 | 10.7.12.1 - 10.7.15.254 | 1022  |

## Build Firmware

```
./build-firmware <edgerouterx|repeaterNN>
```

## Configure

```
cp network-secrets.env.example network-secrets.env # and edit as appropriate
./deploy <edgerouterx|repeaterNN>
```

## Debugging Notes

Wireless Mesh notes (no longer used since 802.11s was to be **really** slow)

```
iw phy0 info
iw --debug event -f
iw dev mesh2 station dump
iw dev mesh2 survey dump
iw mesh2 get power_save
iw dev mesh2 mpath dump
iw dev mesh2 station dump
wifi status
iw dev mesh2  scan
iw dev mesh2 get mesh_param
iw list |grep -i antenna
```

Debugging wifi management frames

```
opkg update
opkg install horst
iw dev mesh2 interface add mon0 type monitor
horst -i mon0

grep -q mon0 /proc/net/dev || /usr/sbin/iw phy phy0 interface add mon0 type monitor;  /sbin/ifconfig mon0 up; /usr/sbin/tcpdump -s 0 -i mon0 -y IEEE802_11_RADIO
grep -q mon0 /proc/net/dev || /usr/sbin/iw phy phy0 interface add mon0 type monitor;  /sbin/ifconfig mon0 up; /usr/sbin/iwcap -i mon0 -s
```

Read wifi stats from ` /sys/kernel/debug/ieee80211/phy1/netdev\:dual2/stations/`
