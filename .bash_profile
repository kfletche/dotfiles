if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

export BASH_SILENCE_DEPRECATION_WARNING=1 # remove bash warning on OS X

alias newmac="sudo /sbin/ifconfig en0 ether \`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'\`"
