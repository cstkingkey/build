#!/usr/bin/env bash

# if error return imediately
#set -e

root="`dirname ${BASH_SOURCE[0]}`"
root="`readlink -f $root`"

case ${OS} in
  linux)
      if [ -z ${STD+x} ];
      then
        declare -x STD="gnu"
      fi

      export RUST_TARGET=$ARCH-unknown-linux-${STD}${ABI}
      export LINUX_TARGET=$ARCH-linux-${STD}${ABI}

      case ${STD} in
        gnu)
          export REAL_ENTRY=$root/linux-entry-clang.sh
          ;;
        musl)
          export REAL_ENTRY=$root/linux-musl-entry-clang.sh
          ;;
      esac
      ;;
  win)
      export REAL_ENTRY=$root/xwin-entry.sh
      export RUST_TARGET=${ARCH}-pc-windows-msvc
      if [[ ${ARCH} == "i"*"86" ]]
      then
         export WIN_ARCH="x86"
      else
         declare -x WIN_ARCH=${ARCH}
      fi
      ;;
  mac)
      export REAL_ENTRY=$root/darwin-entry.sh
      export RUST_TARGET=${ARCH}-apple-darwin
      ;;
esac

. $REAL_ENTRY
exec "$@"
