#!/usr/bin/env bash

set -e

wget $CLANG_URL
tar xf clang.tar.xz -C /usr/local/

case ${OS} in
  linux)
      apt-get -qq install binutils-${LINUX_TARGET} || true
      rootfs=$ROOTFS_URL/rootfs-${deb_arch}.tar.xz
      wget $rootfs
      tar xf rootfs*.tar.xz -C /opt/
      ;;
  win)
      xwin=$XWIN_URL/xwin-${WIN_ARCH}.tar.xz
      wget $xwin
      tar xf xwin*.tar.xz -C /opt/
      ;;
  mac)
      wget $OSXCROSS_URL
      tar xf osxcross.tar.xz -C /usr/local/
      ;;
esac
