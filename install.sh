#!/bin/bash

# Lovingly copied from thoughtbot, inc.
# Distributed under the MIT license, copyright 2009-2013

DO_NOT_COPY="install.sh README.md LICENSE"

copy_files() {
	for name in *; do
	  target="$HOME/.$name"
	  if [ -e "$target" ]; then
		if [ ! -L "$target" ]; then
		  echo "WARNING: Not overwriting existing file $target which is not a symlink."
		fi
	  else
		if [[ ! $DO_NOT_COPY =~ (^|[[:space:]])"$name"($|[[:space:]]) ]]; then
		  echo "Creating $target"
		  ln -s "$PWD/$name" "$target"
		fi
	  fi
	done
}

install_vim_bundles() {
	#if [ ! -e ~/.vim/bundle/vundle ]; then
	#  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
	#fi
	echo "Installing vim bundles..."
	vim -u ~/.vimrc.bundles +BundleInstall +qa
}

#install_oh_my_zsh() {
#	if [ ! -e "$HOME/.oh-my-zsh" ]
#}
use_zsh() {
	if [ "$SHELL" != "/bin/zsh" ]; then
		if ! command zsh; then
			echo "You do not have zsh installed - install then re-run this script."
			exit 1
		fi
		echo "Changing to login shell zsh"
		chsh -s /bin/zsh
		zsh
	fi
	echo "Re-sourcing .zshrc"
	zsh "$HOME/.zshrc"
}

cd "$HOME"

if [ ! -e "dotfiles" ]; then
	if ! git clone https://github.com/fish-face/dotfiles; then
		echo "Unable to clone dotfiles repo."
		exit 1
	fi
fi

cd dotfiles
if ! git pull; then
	echo "Error pulling dotfiles."
	exit 1
fi
git submodule init
git submodule update --recursive
copy_files
install_vim_bundles
use_zsh
