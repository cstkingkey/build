#!/usr/bin/env bash

set -e

export CROSS_TOOLCHAIN_ROOT=/opt/cross-tools
export CROSS_TARGET_ROOT=/opt/rootfs
root="`dirname ${BASH_SOURCE[0]}`/../.."
##root=`pwd`
root="`readlink -f $root`"
declare -x LOCAL_TOOLCHAIN_ROOT=${root}/toolchain
export PATH=${LOCAL_TOOLCHAIN_ROOT}/bin:${PATH}:${CROSS_TOOLCHAIN_ROOT}/bin # eqeuals to declare -x

if [[ ${ARCH} == "i"*"86" ]]
then
   declare -x ARCH2="x86"
else
   declare -x ARCH2=${ARCH}
fi

declare -x CROSS_TARGET=${ARCH}-pc-windows-msvc

envvar_suffix="${CROSS_TARGET//-/_}"
upper_suffix=$(echo ${envvar_suffix} | tr '[:lower:]' '[:upper:]')
declare -x HOST_CC=gcc
declare -x AR_${envvar_suffix}=llvm-lib
declare -x CC_${envvar_suffix}=xwin-clang
declare -x CXX_${envvar_suffix}=xwin-clang
declare -x STRIP_${envvar_suffix}=llvm-strip
declare -x CROSS_STRIP=llvm-strip
## cannot set lld-link as cargo will append -falvor link to the command line leading to error
declare -x CARGO_TARGET_${upper_suffix}_LINKER=lld
declare -x CMAKE_MT=llvm-mt

#CL_FLAGS="-Wno-unused-command-line-argument -fuse-ld=lld-link -I/opt/xwin/crt/include -I/opt/xwin/sdk/include/ucrt -I/opt/xwin/sdk/include/um -I/opt/xwin/sdk/include/shared"
#declare -x CFLAGS_${envvar_suffix}="$CL_FLAGS"
#declare -x CXXFLAGS_${envvar_suffix}="$CL_FLAGS"
declare -x RUSTFLAGS="-Lnative=/opt/xwin/crt/lib/${ARCH2} -Lnative=/opt/xwin/sdk/lib/um/${ARCH2} -Lnative=/opt/xwin/sdk/lib/ucrt/${ARCH2}"

exec "$@"
