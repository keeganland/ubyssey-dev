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
RUN git clone https://github.com/keeganland/ubyssey.ca.git/ /workspaces/ubyssey.ca/
RUN git clone https://github.com/keeganland/dispatch.git/ /workspaces/dispatch/
  
# Set up the Ubyssey.ca Theme repo's dependencies on the container.
RUN pip install -r /workspaces/ubyssey.ca/requirements.txt

# Run set-up script (which is put in workspaces directory, because it needs to manipulate both Dispatch and Ubyssey repos)
RUN cp -r /workspaces/ubyssey.ca/local-dev/ubyssey-setup.sh /workspaces/ubyssey-setup.sh
RUN bash /workspaces/ubyssey-setup.sh
RUN cp -r /workspaces/ubyssey.ca/_settings/settings-local.py /workspaces/ubyssey.ca/ubyssey/settings.py

WORKDIR /workspaces/
ENTRYPOINT ["/workspaces/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]