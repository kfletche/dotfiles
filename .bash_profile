if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

alias newmac="sudo /sbin/ifconfig en0 ether \`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'\`"
