#We build a Dev environment by adding to the from the basic ("production" image) of the site

FROM keeganlandrigan/ubyssey-site:1.0.0

# vim is included for development purposes
RUN apt-get install -y vim
# See https://github.com/nodesource/distributions/blob/master/README.md
RUN apt-get install -y build-essential curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
  
# Install things needed for Ubyssey theme front-end build chain
WORKDIR /workspaces/ubyssey.ca/ubyssey/static/
RUN npm install \
  && npm install -g gulp \
  && npm install -g gulp-cli \
  && npm rebuild node-sass \
  && gulp buildDev

# Set up Dispatch
WORKDIR /workspaces/dispatch
RUN pip install -e .[dev] \
  && python setup.py develop
WORKDIR /workspaces/dispatch/dispatch/static/manager
RUN npm install -g yarn \
  && yarn setup \
  && yarn start-lite

ENTRYPOINT ["/workspaces/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]