#Use this Python 3.8.2-buster image because there's so much to be installed on this container, version ought to be explicit
FROM python:3.8.2-buster
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
  
# Set up the Ubyssey.ca Theme repo on the container.
RUN cp -r /home/ubyssey.ca/_settings/settings-local.py /home/ubyssey.ca/ubyssey/settings.py
WORKDIR /home/ubyssey.ca/
RUN pip install -r requirements.txt


# Ubyssey repo cont'd: Set up nodejs stuff
WORKDIR /home/ubyssey.ca/ubyssey/static
RUN npm i \
  && npm i -g gulp \
  && npm i -g gulp-cli \
  && npm rebuild node-sass \
  && gulp buildDev

WORKDIR /home/

#set up dispatch
WORKDIR /home/dispatch/
RUN pip install -e .[dev] && python setup.py develop
WORKDIR /home/dispatch/dispatch/static/manager
RUN npm install -g yarn && yarn setup
WORKDIR /home/

EXPOSE 8000
ENTRYPOINT ["python", "/home/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]