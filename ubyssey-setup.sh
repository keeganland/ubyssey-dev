#!/bin/bash

# tell Django to use the settings-local file for 
# TODO make this conditional
cp -r /workspaces/ubyssey-dev/ubyssey.ca/_settings/settings-local.py /workspaces/ubyssey-dev/ubyssey.ca/ubyssey/settings.py

apt-get update
apt-get install -y build-essential curl
apt-get install -y nodejs
apt-get install -y npm

#set up the Ubyssey Theme's static directory
#the "yarn install" and "gulp" commands were being done in another container before, for some reason
cd /workspaces/ubyssey-dev/ubyssey.ca/ubyssey/static/
npm install
npm install -g gulp
npm install -g gulp-cli
npm rebuild node-sass
gulp buildDev

#set up dispatch
#the "yarn install" and "yarn start" commands were being done by starting another container before, for some reason
cd /workspaces/ubyssey-dev/dispatch
pip install -e .[dev]
python setup.py develop
cd /workspaces/ubyssey-dev/dispatch/dispatch/static/manager
npm install -g yarn
yarn setup