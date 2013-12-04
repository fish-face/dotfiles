#!/bin/sh

# Lovingly copied from thoughtbot, inc.
# Distributed under the MIT license, copyright 2009-2013

for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: Not overwriting existing file $target which is not a symlink."
    fi
  else
    if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ] && [ "$name" != 'LICENSE' ]; then
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

if [ ! -e ~/.vim/bundle/vundle ]; then
  git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

vim -u ~/.vimrc.bundles +BundleInstall +qa
