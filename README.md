Building firmware

```
scp -v -P23 lede/bin/targets/lantiq/xrx200/lede-lantiq-xrx200-TDW8970-squashfs-sysupgrade.bin root@10.7.11.5:/tmp
ssh -p 23 root@10.7.11.5
echo 3 > /proc/sys/vm/drop_caches
sysupgrade -v /tmp/lede-lantiq-xrx200-TDW8970-squashfs-sysupgrade.bin
```

Making changes to the build

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

Running

```
cp network-secrets.env.example network-secrets.env
# edit as appropriate

source network-secrets.env && envsubst < w8970.envsubst | ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<switch>
```

Debugging

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

Debugging management frames
```
opkg update
opkg install horst
iw dev mesh2 interface add mon0 type monitor
horst -i mon0

grep -q mon0 /proc/net/dev || /usr/sbin/iw phy phy0 interface add mon0 type monitor;  /sbin/ifconfig mon0 up; /usr/sbin/tcpdump -s 0 -i mon0 -y IEEE802_11_RADIO
grep -q mon0 /proc/net/dev || /usr/sbin/iw phy phy0 interface add mon0 type monitor;  /sbin/ifconfig mon0 up; /usr/sbin/iwcap -i mon0 -s
```

For stats we want to read from ` /sys/kernel/debug/ieee80211/phy1/netdev\:dual5/stations/`
