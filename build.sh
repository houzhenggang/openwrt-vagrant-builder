#!/bin/bash

print_time() {

  elapsed_time="$SECONDS"

  if [ "$elapsed_time" -eq 1 ]; then
    units="second"
  else
    units="seconds"
  fi

  echo "Completed in $elapsed_time $units."
}

main() {

  # Display time taken when exiting
  trap print_time EXIT

  cd ~/openwrt
  make clean && make world && cp -Rfv bin/x86/openwrt-x86-kvm_guest-combined-ext4.vdi /vagrant/box
  sudo shutdown -h now
}

main
