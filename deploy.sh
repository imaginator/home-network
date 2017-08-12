#!/bin/sh
set -xe
. ./network-secrets.env 
envsubst \ '
  $trusted_wifikey \
  $dual2_roaming_key \
  $freifunk_roaming_key \
  $henet_tunnelid \
  $henet_username \
  $henet_password \
  $easybell_username \
  $easybell_password \
  $ddns_domain \
  $ddns_username \
  $ddns_password \
  $freifunk_ca_crt \
  $freifunk_client_crt \
  $freifunk_client_key \
  $imagivpn_key \
  $dh2048_pem \
  ' < w8970_w8980.settings  | ssh -p23 root@10.7.11.5
