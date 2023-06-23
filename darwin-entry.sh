#!/usr/bin/env bash

set -e

declare -x OSXCROSS_ROOT=/usr/local/osxcross
declare -x CROSS_SYSROOT=${OSXCROSS_ROOT}/SDK/MacOSX13.1.sdk/usr/

root="`dirname ${BASH_SOURCE[0]}`/../.."
##root=`pwd`
root="`readlink -f $root`"
declare -x LOCAL_TOOLCHAIN_ROOT=${root}/toolchain
export PATH=${LOCAL_TOOLCHAIN_ROOT}/bin:${PATH}:${OSXCROSS_ROOT}/bin # eqeuals to declare -x
declare -x CROSS_TARGET=${ARCH}-apple-darwin

# extract our tools version. credit @0xdeafbeef.
tools=$(compgen -c | grep "${CROSS_TARGET}")
version=$(echo "${tools}" | grep 'ar$' |  sed 's/'"${CROSS_TARGET}"'//' | sed 's/-ar//')

# export our toolchain versions
envvar_suffix="${CROSS_TARGET//-/_}"
upper_suffix=$(echo ${envvar_suffix} | tr '[:lower:]' '[:upper:]')
tools_prefix="${CROSS_TARGET}${version}"
declare -x AR_${envvar_suffix}="${tools_prefix}"-ar
declare -x CC_${envvar_suffix}="${tools_prefix}"-clang
declare -x CXX_${envvar_suffix}="${tools_prefix}"-clang++
declare -x STRIP_${envvar_suffix}="${tools_prefix}"-strip
declare -x CROSS_STRIP="${tools_prefix}"-strip
declare -x CARGO_TARGET_${upper_suffix}_LINKER="${tools_prefix}"-clang

declare -x CFLAGS_${envvar_suffix}="-stdlib=libc++ -fuse-ld=${OSXCROSS_ROOT}/bin/${tools_prefix}-ld"
declare -x CXXFLAGS_${envvar_suffix}="-stdlib=libc++ -fuse-ld=${OSXCROSS_ROOT}/bin/${tools_prefix}-ld"

exec "$@"
