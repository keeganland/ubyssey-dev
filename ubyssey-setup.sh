#!/bin/bash

# tell Django to use the settings-local file for 
# TODO make this conditional
cp -r ubyssey.ca/_settings/settings-local.py ubyssey.ca/ubyssey/settings.py

# in the original instructions this would be where we would run 'docker-compose up'. The point of this setup file though is that we're running on the Docker container already.
# so instead, we're going to ensure dependinces are installed
#cd ubyssey.ca
apt-get update
apt-get -y install build-essential curl
apt-get install -y nodejs
apt-get install -y npm

#set up the Ubyssey Theme's static directory
#the "yarn install" and "gulp" commands were being done in another container before, for some reason
cd /ubyssey.ca/ubyssey/static/
npm install
npm install -g gulp
npm install -g gulp-cli
npm rebuild node-sass
gulp buildDev
yarn install
gulp

#set up dispatch
#the "yarn install" and "yarn start" commands were being done by starting another container before, for some reason
cd /home/dispatch
pip install -e .[dev]
python setup.py develop
cd /home/dispatch/dispatch/static/manager
npm install -g yarn
yarn setup
yarn install
yarn start

#start server
python /home/ubyssey.ca/manage.py runserver 0.0.0.0:8000
