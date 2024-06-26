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

if [[ ${ARCH} == "i"*"86" ]]
then
   declare -x ARCH2="i386"
else
   declare -x ARCH2=${ARCH}
fi

declare -x CROSS_TARGET=${ARCH}-unknown-linux-gnu${ABI}
declare -x CROSS_TARGET2=${ARCH2}-linux-gnu${ABI}

case ${ARCH} in
  x86_64|aarch64|i686|powerpc64le|arm)
      export REAL_LD=lld
      ;;
  *)
      export REAL_LD=/usr/bin/${CROSS_TARGET2}-ld
      ;;
esac

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

#declare -x CFLAGS_${envvar_suffix}="-fPIC"
#declare -x CXXFLAGS_${envvar_suffix}="-fPIC"

case ${ARCH} in
  mips64el|loongarch64|s390x)
      declare -x RUSTFLAGS="-Clink-args=-Wl,-rpath-link,${CROSS_TARGET_ROOT}/usr/lib/${CROSS_TARGET2} -Clink-args=-Wl,-rpath-link,${CROSS_TARGET_ROOT}/lib/${CROSS_TARGET2} -Clink-args=-Wl,-rpath-link,${CROSS_TARGET_ROOT}/usr/lib64"
      ;;
  *)
      ;;
esac

#exec "$@"
