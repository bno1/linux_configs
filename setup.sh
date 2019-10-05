#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SRCPATH=$(dirname "$SCRIPTPATH")

echo "Repo path: $SRCPATH"

echo "Installing configs"

mkdir -p "$HOME/.config/htop/"
ln -fiTnsv "$SRCPATH/.config/htop/htoprc" "$HOME/.config/htop/htoprc"

ln -fiTnsv "$SRCPATH/.vimrc"        "$HOME/.vimrc"
ln -fiTnsv "$SRCPATH/.profile"      "$HOME/.profile"
ln -fiTnsv "$SRCPATH/.bash_profile" "$HOME/.bash_profile"
ln -fiTnsv "$SRCPATH/.bashrc"       "$HOME/.bashrc"
ln -fiTnsv "$SRCPATH/.tmux.conf"    "$HOME/.tmux.conf"
ln -fiTnsv "$SRCPATH/.gdbinit"      "$HOME/.gdbinit"
ln -fiTnsv "$SRCPATH/.pylintrc"     "$HOME/.pylintrc"
ln -fiTnsv "$SRCPATH/.Xresources"   "$HOME/.Xresources"

echo "Replacing $HOME/.vim"
rm -rfIv "$HOME/.vim"
ln -fiTnsv "$SRCPATH/.vim" "$HOME/.vim"

echo "Replacing $HOME/.config/nvim"
rm -rfIv "$HOME/.config/nvim"
ln -fiTnsv "$SRCPATH/.config/nvim" "$HOME/.config/nvim"

echo "Replacing $HOME/.tmux"
rm -rfIv "$HOME/.tmux"
ln -fiTnsv "$SRCPATH/.tmux" "$HOME/.tmux"

echo
echo "Installing tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
