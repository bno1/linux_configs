#!/bin/bash

SCRIPTPATH=`realpath $0`
SRCPATH=`dirname "$SCRIPTPATH"`

echo "Repo path: $SRCPATH"

echo "Installing configs"

mkdir -p ~/.config/htop/
ln -fiTnsv $SRCPATH/.config/htop/htoprc ~/.config/htop/htoprc

ln -fiTnsv $SRCPATH/.vimrc ~/.vimrc
ln -fiTnsv $SRCPATH/.bashrc ~/.bashrc
ln -fiTnsv $SRCPATH/.tmux.conf ~/.tmux.conf
ln -fiTnsv $SRCPATH/.gdbinit ~/.gdbinit
ln -fiTnsv $SRCPATH/.pylintrc ~/.pylintrc

echo "Replacing ~/.vim"
rm -rfIv ~/.vim
ln -fiTnsv $SRCPATH/.vim ~/.vim

echo "Replacing ~/.tmux"
rm -rfIv ~/.tmux
ln -fiTnsv $SRCPATH/.tmux ~/.tmux

echo
echo "Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
