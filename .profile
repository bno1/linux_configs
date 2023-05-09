#!/bin/sh

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/gocode/bin:$PATH"

export GOPATH="$HOME/gocode"

if hash rustc 2>/dev/null; then
    RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    export RUST_SRC_PATH
fi

export WINEDLLOVERRIDES="winemenubuilder.exe=d"

export PAGER=less
export EDITOR=nvim

#export MOZ_DISABLE_RDD_SANDBOX=1
export NVD_BACKEND=direct

export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl
