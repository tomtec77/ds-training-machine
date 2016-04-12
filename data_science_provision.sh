#!/bin/bash

# First update the system
echo "Updating the base system..."
CONTROL=1
sudo apt-get update
until [ $CONTROL -eq 0 ]; do
    sudo apt-get -y dist-upgrade
    CONTROL=$?
done

# Install xauth if it isn't present, required for X11
echo "Installing xauth if not present..."
CONTROL=1
until [ $CONTROL -eq 0 ]; do
    sudo apt-get install -y xauth
    CONTROL=$?
done

# Install several useful packages
echo "Installing extra packages..."
CONTROL=1
until [ $CONTROL -eq 0 ]; do
    sudo apt-get install -y git subversion curl vim
    CONTROL=$?
done

# Add the following to file .bashrc to enable a custom prompt
cat <<EOT >> /home/vagrant/.bashrc
# Add a custom color prompt
CUSTOM_PROMPT="~"
bldylw='\e[1;33m'
bldgrn='\e[1;32m'
bldblu='\e[1;34m'
txtrst='\e[0m'
print_before_the_prompt () {
printf "\$bldylw[ \$bldgrn%s@%s: \$bldblu%s \$bldylw]\n\$txtrst" "\$USER" "\$HOSTNAME" "\${PWD/\$HOME/\$CUSTOM_PROMPT}"
}
PROMPT_COMMAND=print_before_the_prompt
PS1='~> '
EOT

# Download and install Anaconda Python, and create useful aliases
echo "Downloading and installing Anaconda Python..."
CONTROL=1
until [ $CONTROL -eq 0 ]; do
    wget --progress=bar:force http://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh -O /home/vagrant/Anaconda2.sh
    CONTROL=$?
done
bash /home/vagrant/Anaconda2.sh -b -p /home/vagrant/anaconda2

cat <<EOT >> /home/vagrant/.bash_aliases
# Anaconda 2 aliases
CONDA_HOME=\$HOME/anaconda2/
alias activate='source \$CONDA_HOME/bin/activate'
alias deactivate='source \$CONDA_HOME/bin/deactivate'
alias conda='\$CONDA_HOME/bin/conda'
EOT

# Add the R channel to the conda package manager sources
cat <<EOT >> /home/vagrant/anaconda2/.condarc
# Channel locations. These override conda defaults, i.e. conda will
# search *only* the channels listed here, in the order given. Use "defaults" to
# automatically include all default channels. Non-URL channels will be
# interpreted as Anaconda.org usernames (this can be changed by modifying the
# channel_alias key; see below). The default is just "defaults".
channels:
  - r
  - defaults
# Show channel URLs when displaying what is going to be downloaded and
# in "conda list". The default is False.
show_channel_urls: True
EOT

# Check for available Anaconda updates
echo "Checking for Anaconda updates..."
/home/vagrant/anaconda2/bin/conda update -y conda

# Add CRAN R repository to the list of package sources
sudo /bin/sh -c 'echo "deb http://www.vps.fmvz.usp.br/CRAN/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list'

# Add the R repository key
cat <<EOT >> /home/vagrant/key.txt
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.5
Comment: Hostname: pgp.mit.edu
mQGiBEXUFiURBADkTqPqcRYdLIguhC6fnwTvIxdkoN1UEBuPR6NYW4iJzvRSas/g5bPo5ZxE
2i5BXiuVfYrSk/YiU+/lc0K6VYNDygbOfpBgGGhtfzYfFRTYNq8QsdD8L8BMYtOu5rYo5BYt
a0vuantIS9mn9QnH7885uy5tX/TXO7ICYVHxnFNr2wCguNtMdz9+DRQ38n4iiHzTtj/7UHsD
/0+0TLHHvY1FfakVinamR9oCm9uH9PmkGTy6jRnrvg5Z+TTgygiDdTBKPc1TqpFgoFtqh8G5
DpDPbyh5GzBj8Ky1mBJb3bMwy2RUth1cztHEWI36xuCl+KrLtA4OYuCwJJZhOWDIO9aO2LW5
kJhIwIuvSrEtOgTxpzy82g7eEzvLBADUrQ01fj+9VDrO2Vept8jtaGK+4kW3cBAG/UbOrTjt
63VurXwyvNb6q7hKFUaVH42Fc0e64F217mutCyftPWYJwY4SR8hUmjEM/SYcezUDWWvVxmkF
8M4rMhHa0j+q+et3mTKwgxehQO9hLUqRebnmJuwNqNJKb9izsPqmh83Zo7Q7Sm9oYW5uZXMg
UmFua2UgKENSQU4gRGViaWFuIGFyY2hpdmUpIDxqcmFua2VAdW5pLWJyZW1lbi5kZT6IRgQQ
EQIABgUCRdQ+nQAKCRAvD04U9kmvkJ3+AJ4xLMELB/fT1AwtR1azcH0lKg/TegCdEvtp3SUf
aHP3Jvg2CkzTZOatfFuIRgQQEQIABgUCS4VoCgAKCRDvfNpxC67+5ZFyAKCAzgPTqM6sSMhB
iaZbNCpiVtwDrQCgjMy+iqPm7SVOCq0XJsCCbxymfB+IXgQTEQIAHgUCRdQWJQIbAwYLCQgH
AwIDFQIDAxYCAQIeAQIXgAAKCRAG+Q3lOBukgM09AKCuapN6slttAFRjs2/mgtaMMwO9sgCf
ZD2au39Oo8QLXZhZTipN8c7j9mM=
=BRgm
-----END PGP PUBLIC KEY BLOCK-----
EOT
sudo apt-key add /home/vagrant/key.txt

# Install R
echo "Installing R..."
CONTROL=1
sudo apt-get update
until [ $CONTROL -eq 0 ]; do
    sudo apt-get install -y r-recommended
    CONTROL=$?
done

# Install RStudio
echo "Downloading and installing RStudio..."
CONTROL=1
until [ $CONTROL -eq 0 ]; do
    wget --progress=bar:force https://download1.rstudio.org/rstudio-0.99.893-amd64.deb -O /home/vagrant/rstudio.deb
    CONTROL=$?
done
CONTROL=1
until [ $CONTROL -eq 0 ]; do
    sudo apt-get install -y libgstreamer-plugins-base0.10-0 libgstreamer0.10-0 liborc-0.4-0 libxslt1.1 libgl1-mesa-dri libgl1-mesa-glx xcb
    CONTROL=$?
done
sudo dpkg -i /home/vagrant/rstudio.deb

# Delete downloaded installation packages and temp files
echo "Cleaning up..."
rm /home/vagrant/rstudio.deb /home/vagrant/Anaconda2.sh /home/vagrant/key.txt
echo "Provisioning complete."
