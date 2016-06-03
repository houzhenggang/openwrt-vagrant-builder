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

  # Adapted from instructions on https://wiki.openwrt.org/doc/howto/buildroot.exigence
  OPENWRT_VERSION="15.05"
  OPENWRT_BRANCH="master"

  sudo apt-get update && sudo apt-get -y install \
    git-core \
    build-essential \
    libssl-dev \
    libncurses5-dev \
    unzip \
    gawk \
    subversion \
    mercurial

  cd ~

  if [ ! -d ~/openwrt/.git ]; then
    git clone "git://git.openwrt.org/${OPENWRT_VERSION}/openwrt.git" openwrt
  fi

  cd ~/openwrt
  git checkout -f -t -B "${OPENWRT_BRANCH}" "origin/${OPENWRT_BRANCH}"
  git pull

  # Display most recent commit for reference
  git log --oneline -n 1
  
  ./scripts/feeds update -a
  ./scripts/feeds install -a

  # Get content from shared folder with vagrant user and default permissions
  rsync -av --no-o --no-g --no-p --chmod=D755,F644 /vagrant/src/ ~/openwrt

  cp -v diffconfig .config
  make defconfig
  make prereq

  # All done! Proceed to build OpenWrt, or explore the provisioned build environment.
}

main
