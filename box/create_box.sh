#!/bin/bash

# List of references and sources of inspiration: 
#
# https://github.com/lifeeth/openwrt-in-vagrant/blob/master/utils/create_box.sh
# http://hoverbear.org/2014/11/23/openwrt-in-virtualbox/
# https://wiki.openwrt.org/doc/howto/virtualbox

VMNAME="openwrt-base-x86"
VDI="./openwrt-x86-kvm_guest-combined-ext4.vdi"

hash VBoxManage 2>/dev/null || { echo >&2 "VBoxManage command is not available, exiting with error."; exit 1; }

VBoxManage createvm --name $VMNAME --register && \
VBoxManage modifyvm $VMNAME \
  --ostype "Linux26" \
  --memory "32" \
  --cpus "1" \
  --nic1 "nat" \
  --natpf1 "ssh,tcp,127.0.0.1,2222,,22" && \
VBoxManage storagectl $VMNAME \
  --name "IDE Controller" \
  --add "ide" \
  --portcount "2" \
  --hostiocache "on" \
  --bootable "on" && \
VBoxManage storageattach $VMNAME \
  --storagectl "IDE Controller" \
  --port "0" \
  --device "0" \
  --type "hdd" \
  --nonrotational "off" \
  --medium $VDI

# Remove any leftover box files
rm -fv openwrt.box

# Detach storage before deleting VM files so the VDI does not get removed
vagrant package --base $VMNAME --include _Vagrantfile --output openwrt.box && \
VBoxManage storageattach $VMNAME \
  --storagectl "IDE Controller" \
  --port "0" \
  --device "0" \
  --medium none && \
VBoxManage closemedium disk $VDI && \
VBoxManage unregistervm $VMNAME --delete
