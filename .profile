export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/gocode/bin:$PATH

export GOPATH=$HOME/gocode

RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_SRC_PATH

export WINEDLLOVERRIDES="winemenubuilder.exe=d"

export PAGER=less
export EDITOR=vim
