# Home Network

This is the code that configures my home network. The network consists of the following gear:
- TP-Link W8970 DSL router
- TP-Link W8980B DSL router as a backup
- 3x Ubiquiti NanostationM2 Locos

The network is monitored at: https://bunker.imaginator.com/grafana/dashboard/db/wifi using the (Prometheus Node Exporter)[https://github.com/openwrt/packages/tree/master/utils/prometheus-node-exporter-lua].

## Diagram
```
  ^                
  |  uplink VDSL  (easybell, ptm0.7 etc)
  |  ipv6 tunnel  (henet)
  |  freifunk vpn (ffvpn)
  |
+-+-----------------------------------------------------------------+
| imagiswitch.imagilan                                              |
|===================================================================|
| br-trusted (eth0.2, dual2)    <---> wan-trusted (easybell, henet) +------>wifi: dual2
| br-notrust (eth0.3, freifunk) <---> wan|notrust (ff-vpn)          +------>wifi: freifunk
+-+-----------------------------------------------------------------+
  |
  |  vlan2 (eth0.2)
  |  vlan3 (eth0.3)
  |
  |    +---------------------------------+
  |    |  repeater01.imagilan            |
  |    |=================================|
  +----+  br-trusted (eth0.2, dual2)     +------>wifi: dual2
  |    |  br-notrust (eth0.3, freifunk)  +------>wifi: freifunk
  |    +---------------------------------+
  |
  |    +---------------------------------+
  |    |  repeater<nn>.imagilan          |
  |    |=================================|
  +----+  br-trusted (eth0.2, dual2)     |------>wifi: dual2
       |  br-notrust (eth0.3, freifunk)  +------>wifi: freifunk
       +---------------------------------+
```




Building the W8970 and W8980 firmware

```
# Upgrade build configs
cd lede-w8970
make menuconfig # twiddle packages and save
scripts/diffconfig.sh  > /tmp/out
diff ../w8970.diffconfig /tmp/out
# edit ../w8970.diffconfig with any changes
cd .. 
./w8970-build.sh
scp -v -P23 lede/bin/targets/lantiq/xrx200/lede-lantiq-xrx200-TDW8970-squashfs-sysupgrade.bin root@10.7.11.5:/tmp
ssh -p 23 root@10.7.11.5
echo 3 > /proc/sys/vm/drop_caches
sysupgrade -v /tmp/lede-lantiq-xrx200-TDW8970-squashfs-sysupgrade.bin
```

Configuring the routers

```
cp network-secrets.env.example network-secrets.env
# edit as appropriate

source network-secrets.env && envsubst < w8970.settings | ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<device>
```

Debugging Wireless

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

For stats we want to read from ` /sys/kernel/debug/ieee80211/phy1/netdev\:dual5/stations/`
