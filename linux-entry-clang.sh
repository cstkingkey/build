#!/usr/bin/env bash

set -e

export CROSS_TOOLCHAIN_ROOT=/opt/cross-tools
export CROSS_TARGET_ROOT=/opt/rootfs
root="`dirname ${BASH_SOURCE[0]}`"
root="`readlink -f $root`"
declare -x LOCAL_TOOLCHAIN_ROOT=${root}/toolchain
export PATH=${LOCAL_TOOLCHAIN_ROOT}/bin:${PATH}:${CROSS_TOOLCHAIN_ROOT}/bin
## openssl-sys need it.
export PKG_CONFIG_ALLOW_CROSS=1

declare -x CROSS_TARGET=${ARCH}-unknown-linux-gnu${ABI}
declare -x CROSS_TARGET2=${ARCH}-linux-gnu${ABI}

declare -x CFLTK_TOOLCHAIN="${root}/cross.cmake"

export LLVM_VERSION=$(compgen -c | grep -E clang-[0-9]+ | sed 's/clang-//' | sort -rn | head -n 1)

# export our toolchain versions
envvar_suffix="${CROSS_TARGET//-/_}"
upper_suffix=$(echo ${envvar_suffix} | tr '[:lower:]' '[:upper:]')
declare -x CC=linux-clang
declare -x CXX=linux-clang
declare -x HOST_CC=clang
declare -x AR_${envvar_suffix}=llvm-ar
declare -x CC_${envvar_suffix}=linux-clang
declare -x CXX_${envvar_suffix}=linux-clang++
declare -x STRIP_${envvar_suffix}=llvm-strip
declare -x CROSS_STRIP=llvm-strip
declare -x CARGO_TARGET_${upper_suffix}_LINKER=linux-clang

# use env to avoid hacking pc files
declare -x PKG_CONFIG_SYSROOT_DIR=${CROSS_TARGET_ROOT}
declare -x PKG_CONFIG_PATH="${CROSS_TARGET_ROOT}/usr/lib/${CROSS_TARGET2}/pkgconfig/:${CROSS_TARGET_ROOT}/usr/share/pkgconfig/:${PKG_CONFIG_PATH}"

exec "$@"