#!/bin/bash

cd /tmp/
git clone https://aur.archlinux.org/auracle-git.git
git clone https://aur.archlinux.org/pacaur.git
cd auracle-git/
makepkg -fsri --noconfirm
cd ..
cd pacaur/
makepkg -fsri --noconfirm

exit

