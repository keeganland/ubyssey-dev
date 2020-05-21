#We build a Dev environment by adding to the from the basic ("production" image) of the site
FROM keeganlandrigan/ubyssey-site:1.0.0

# Run set-up script (which is put in workspaces directory, because it needs to manipulate both Dispatch and Ubyssey repos)
WORKDIR /workspaces/
# RUN cp -r /workspaces/ubyssey.ca/local-dev/ubyssey-setup.sh /workspaces/ubyssey-setup.sh
# RUN bash /workspaces/ubyssey-setup.sh

# setup copied very literally from ubyssey-setup.sh
RUN apt-get update
RUN apt-get install -y build-essential curl
RUN apt-get install -y nodejs
RUN apt-get install -y npm

#set up the Ubyssey Theme's static directory
WORKDIR /workspaces/ubyssey.ca/ubyssey/static/
RUN rm -rf node_modules
RUN npm install
RUN npm install -g gulp
RUN npm install -g gulp-cli
RUN npm rebuild node-sass
RUN gulp buildDev

#set up dispatch
WORKDIR /workspaces/dispatch
RUN pip install -e .[dev]
RUN python setup.py develop
WORKDIR /workspaces/dispatch/dispatch/static/manager
RUN rm -rf node_modules
RUN npm run-script start-lite

ENTRYPOINT ["/workspaces/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]