# This Docker file is to do one job. It is to set up an image of a container that can run, and no more.
# Once this container can run, set up happens using the set up shell script that it contains.
# This is so the same image can be deployed to many different environments, but set up runs differently due to different environmental variables

#Use this Python 3.8.2-buster image because there's so much to be installed on this container, version ought to be explicit
FROM python:3.8.2-buster
ENV PYTHONUNBUFFERED 1
RUN export DEBIAN_FRONTEND=noninteractive

# vim is included for development purposes
RUN apt-get update \
  && apt-get install -y git \
  && apt-get install -y vim
  
# Clone the relevant repos
RUN git clone https://github.com/keeganland/ubyssey.ca.git/ /home/ubyssey.ca/
RUN git clone https://github.com/keeganland/dispatch.git/ /home/dispatch/
RUN git clone https://github.com/keeganland/ubyssey-dev/ /home/ubyssey-dev/
  
# Set up the Ubyssey.ca Theme repo on the container.
#RUN cp -r /home/ubyssey.ca/_settings/settings-local.py /home/ubyssey.ca/ubyssey/settings.py
RUN pip install -r /home/ubyssey.ca/requirements.txt


# Ubyssey repo cont'd: Set up nodejs stuff
#WORKDIR /home/ubyssey.ca/ubyssey/static
#RUN npm i \
#  && npm i -g gulp \
#  && npm i -g gulp-cli \
#  && npm rebuild node-sass \
#  && gulp buildDev

WORKDIR /home/

#set up dispatch
#WORKDIR /home/dispatch/
#RUN pip install -e .[dev] && python setup.py develop
#WORKDIR /home/dispatch/dispatch/static/manager
#RUN npm install -g yarn && yarn setup
#WORKDIR /home/

#EXPOSE 8000
ENTRYPOINT ["/home/ubyssey-dev/ubyssey-setup.sh"]