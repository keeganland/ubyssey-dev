#!/bin/bash

# Create a virtualenv. These steps will not be necessary on a docker container
virtualenv ubyssey-dev
source ubyssey-dev/bin/activate

# clone the git repos
cd ubyssey-dev
git clone https://github.com/keeganland/ubyssey.ca.git/
git clone https://github.com/keeganland/dispatch.git/

# move the Docker settings to ubyssey-dev root
cp -r ./ubyssey.ca/local-dev/. .

# tell Django to use the settings-local file for 
# TODO make this conditional
cp -r ubyssey.ca/_settings/settings-local.py ubyssey.ca/ubyssey/settings.py

# in the original instructions this would be where we would build an run the docker container. The point of this file though is that we don't wanna do this
# so instead, we're going to ensure dependinces are installed
#cd ubyssey.ca
#apt-get update
#apt-get -y install build-essential curl
#apt-get install -y nodejs
#apt-get install -y npm
#pip install -r requirements.txt

#set up the Ubyssey Theme's static directory
#cd /ubyssey.ca/ubyssey/static/
#npm install
#npm install -g gulp
#npm install -g gulp-cli
#npm rebuild node-sass
#gulp buildDev
#cd ..
#cd ..
#cd ..
#cd ..

#set up dispatch
#cd dispatch
#pip install -e .[dev]
#python setup.py develop
#cd dispatch/static/manager
#npm install -g yarn
#yarn setup
#cd ..
#cd ..
#cd ..
#cd ..
#cd ubyssey.ca
#python manage.py runserver 0.0.0.0:8000

