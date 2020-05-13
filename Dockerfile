# This Dockerfile should be moved to a directory containing both ubyssey.ca and dispatch repos
# This docker image runs on Debian Jessie, a popular linux distro
FROM python:3
ENV PYTHONUNBUFFERED 1
RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install build-essential curl \
  && apt-get install -y nodejs \
  && apt-get install -y npm \
  && apt-get install -y git
  
# Clone the relevant repos
RUN git clone https://www.github.com/keeganland/ubyssey.ca.git/ /home/ubyssey.ca/
RUN git clone https://www.github.com/keeganland/dispatch.git/ /home/dispatch/
  
# Set up the Ubyssey.ca repo on the container
# "COPY ./ubyssey.ca ./ubyssey.ca" is a strange looking line, because it seems eventually everything will get copied
# However, the copying of the files has to have already happened so pip
#COPY ./ubyssey.ca ./ubyssey.ca
RUN cp -r /home/ubyssey.ca/_settings/settings-local.py /home/ubyssey.ca/ubyssey/settings.py
WORKDIR /home/ubyssey.ca/
RUN pip install -r requirements.txt

# On "RUN pip install -r requirements.txt":
# This command at some point causes the following:
# What are these git repos?
##  Cloning git://github.com/ubyssey/django-google-storage.git (to revision v0.5.4) to /tmp/pip-install-qxxkdk2c/django-google-storage-updated
##  Running command git clone -q git://github.com/ubyssey/django-google-storage.git /tmp/pip-install-qxxkdk2c/django-google-storage-updated

# RUN cp _settings/settings-local.py ubyssey/settings.py
## "RUN cp _settings/settings-local.py ubyssey/settings.py" seems pointless, because it was necessary to use this settings.py to run docker-compose up at all

# Ubyssey repo cont'd: Set up nodejs stuff
WORKDIR /home/ubyssey.ca/ubyssey/static
RUN npm i \
  && npm i -g gulp \
  && npm i -g gulp-cli \
  && npm rebuild node-sass \
  && gulp buildDev

#Navigate back to home, I think?? We're at ubyssey.ca/ubyssey/static, so going back three is root
WORKDIR /home/

#set up dispatch
#copying happens now, so when calls on pip install and npm install happen, they are 
#COPY ./dispatch ./dispatch
WORKDIR /home/dispatch/
RUN pip install -e .[dev] && python setup.py develop
WORKDIR /home/dispatch/dispatch/static/manager
RUN npm install -g yarn && yarn setup
WORKDIR /home/

EXPOSE 8000
ENTRYPOINT ["python", "/home/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]