#!/bin/bash

# tell Django to use the settings-local file for 
# TODO make this conditional
cp -r ubyssey.ca/_settings/settings-local.py ubyssey.ca/ubyssey/settings.py

#set up the Ubyssey Theme's static directory
#the "yarn install" and "gulp" commands were being done in another container before, for some reason
cd /home/ubyssey.ca/ubyssey/static/
npm install
npm install -g gulp
npm install -g gulp-cli
npm rebuild node-sass
gulp buildDev

#set up dispatch
#the "yarn install" and "yarn start" commands were being done by starting another container before, for some reason
cd /home/dispatch
pip install -e .[dev]
python setup.py develop
cd /home/dispatch/dispatch/static/manager
npm install -g yarn
yarn setup

# database migrations 
cd /home/ubyssey.ca/
python manage.py migrate

#start server
python /home/ubyssey.ca/manage.py runserver 0.0.0.0:8000