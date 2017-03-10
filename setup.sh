#!/bin/bash

SCRIPTPATH=`realpath $0`
SRCPATH=`dirname "$SCRIPTPATH"`

echo $SRCPATH

mkdir -p ~/.config/htop/
ln -fiTns $SRCPATH/.config/htop/htoprc ~/.config/htop/htoprc

ln -fiTns $SRCPATH/.vimrc ~/.vimrc
ln -fiTns $SRCPATH/.bashrc ~/.bashrc
ln -fiTns $SRCPATH/.tmux.conf ~/.tmux.conf
ln -fiTns $SRCPATH/.gdbinit ~/.gdbinit
ln -fiTns $SRCPATH/.pylintrc ~/.pylintrc

rm -rfI ~/.vim
ln -fiTns $SRCPATH/.vim ~/.vim

rm -rfI ~/.tmux
ln -fiTns $SRCPATH/.tmux ~/.tmux
~/.tmux/plugins/tpm/bin/install_plugins
