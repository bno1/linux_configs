# Linux configs

This repo contains my personal configuration files for Linux.

Vim plugins:
  * Pathogen
  * Syntastic
  * YouCompleteMe
  * EasyAlign
  * GhcMod
  * Neco-ghc
  * Vimproc (dependecy of GhcMod)
  * Thrift (syntax highlight)

Tmux plugins:
  * TPM
  * Tmux-sensible
  * Tmux-yank

# Installation

Open a terminal and `cd` into your desired parent folder for this repo, then run:
```bash
git clone 'https://github.com/bno1/linux_configs.git'
cd linux_configs && git submodule update --init --recursive
```

Then you have to build `.vim/bundle/vimproc.vim/` and `.vim/bundle/YouCompleteMe/`.
Check their READMEs for instructions on how to do that.

After bulding them run:
```bash
./setup.sh
```
This will generate the symbolic links to this repo. It will prompt you before each
change.

Keep the repo on your filesystem.
