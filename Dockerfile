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
RUN git clone https://github.com/keeganland/ubyssey-dev/ /workspace/
RUN git clone https://github.com/keeganland/ubyssey.ca.git/ /workspace/ubyssey.ca/
RUN git clone https://github.com/keeganland/dispatch.git/ /workspace/dispatch/
  
# Set up the Ubyssey.ca Theme repo's dependencies on the container.
RUN pip install -r /workspace/ubyssey.ca/requirements.txt

WORKDIR /workspace/

ENTRYPOINT ["/home/ubyssey-dev/ubyssey-setup.sh"]