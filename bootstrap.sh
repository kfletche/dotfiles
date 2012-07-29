################################################################################# 
# Install:                                                                      # 
#  curl -Lo- https://raw.github.com/kfletche/profile/master/bootstrap.sh | bash #
#################################################################################

function die()
{
    echo "${@}"
    exit 1
}

PROFILE=(texmf .NERDTreeBookmarks .bash_profile .bashrc .git .gitconfig \
.gitmodules .latexmkrc .vimperatorrc .vim .vimrc .vimrc.after)

TMP="/tmp/profile-tmp"

# Add <strong>.old</strong> to any existing Vim file in the home directory
for i in $HOME/${PROFILE[*]}; do
  if [[ ( -e $i ) || ( -h $i ) ]]; then
    echo "${i} has been renamed to ${i}.old"
    mv "${i}" "${i}.old" || die "Could not move ${i} to ${i}.old"
  fi
done

# Clone kfletche profile to $TMP
git clone https://github.com/kfletche/profile.git $TMP \
  || die "Could not clone the repository to ${TMP}"

# Move $TMP to $HOME
for x in $TMP/* $TMP/.[!.]* $TMP/..?*; do
  if [ -e "$x" ]; then
    mv -- "$x" $HOME/ || die "Could not move ${x} to ${HOME}"
  fi
done

# Remove $TMP
rmdir $TMP || die "Could not remove $TMP"

# Init & update submodules
git submodule init || die "Could not submodule init in ${HOME}"
git submodule update || die "Could not pull submodules in ${HOME}"

# Pull submodules
git submodule foreach git pull origin master \
  || die "Could not pull submodules in ${HOME}"

# Run rake inside .vim for janus
cd $HOME/.vim || die "Could not go into the ${HOME}/.vim"
rake || die "Rake for Janus failed."
