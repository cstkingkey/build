#!/usr/bin/env bash

set -e

root="`dirname ${BASH_SOURCE[0]}`"
root="`readlink -f $root`"

case ${OS} in
  linux)
      export REAL_ENTRY=$root/linux-entry-clang.sh
      export RUST_TARGET=$ARCH-unknown-linux-gnu${abi}
      export LINUX_TARGET=$ARCH-linux-gnu${abi}
      ;;
  win)
      export REAL_ENTRY=$root/xwin-entry.sh
      export RUST_TARGET=${ARCH}-pc-windows-msvc
      if [[ ${ARCH} == "i"*"86" ]]
      then
        #delare -x is not working
         export WIN_ARCH="x86"
      else
         export WIN_ARCH=${ARCH}
      fi
      ;;
  mac)
      export REAL_ENTRY=$root/darwin-entry.sh
      export RUST_TARGET=${ARCH}-apple-darwin
      ;;
esac

#$root/$REAL_ENTRY "$@"
