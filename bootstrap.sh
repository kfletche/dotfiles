#!/bin/bash

################################################################################# 
# Install:                                                                      # 
#  curl -Lo- https://raw.github.com/kfletche/profile/master/bootstrap.sh | bash #
#################################################################################

function die()
{
    echo "${@}"
    exit 1
}

TMP="/tmp/profile.tmp"

for i in "~/.vim" "~/.vimrc" "~/.git"; do
  if [ -e $i ]; then
    echo "${i} has been renamed to ${i}.old"
    mv "${i}" "${i}.old" || die "Could not move ${i} to ${i}.old"
  fi
done

# clone profile to $TMP
git clone https://github.com/kfletche/profile.git $TMP \
  || die "Could not clone the repository to ${TMP}"

# move $TMP to ~
for x in $TMP/* $TMP/.[!.]* $TMP/..?*; do
  if [ -e "$x" ]; then
    mv -- "$x" ~/ || die "Could not move ${x} to ~"
  fi
done

rmdir $TMP || die "Could not remove $TMP"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
  || die "Could not install vundle."

vim +PluginInstall +qall || die "Vundle plugin install failed."

~/.vim/bundle/YouCompleteMe/install.py --clang-completer \
  || die "Couldn't finish installing YouCompleteMe plugin.."

