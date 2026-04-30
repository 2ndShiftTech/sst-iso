#!/bin/bash

project=$(basename `pwd`)
echo "-----------------------------------------------------------------------------"
echo "this is project https://github.com/2ndShiftTech/"$project
echo "Originally made by: Erik Dubois"
echo "Edited for personal use by: 2nd Shift Technician"
echo "-----------------------------------------------------------------------------"
git config --global pull.rebase false
git config --global user.name "2ndShiftTech"
git config --global user.email "secondshifttech@proton.me"
sudo git config --system core.editor nano
git config --global push.default simple

git remote set-url origin git@github.com:2ndShiftTech/$project

echo "Everything set"

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
