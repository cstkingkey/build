#!/usr/bin/env bash

case ${ARCH} in
  mips|mipsel|mips64el)
      rustup run nightly cargo build -Zbuild-std --target ${RUST_TARGET} --examples --release
      ;;
  *)
      cargo build --target ${RUST_TARGET} --examples --release
      ;;
esac

