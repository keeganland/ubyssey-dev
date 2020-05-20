#We build a Dev environment by adding to the from the basic ("production" image) of the site
FROM keeganlandrigan/ubyssey-site:1.0.0

# Run set-up script (which is put in workspaces directory, because it needs to manipulate both Dispatch and Ubyssey repos)
WORKDIR /workspaces/
RUN cp -r /workspaces/ubyssey.ca/local-dev/ubyssey-setup.sh /workspaces/ubyssey-setup.sh
RUN bash /workspaces/ubyssey-setup.sh

ENTRYPOINT ["/workspaces/ubyssey.ca/manage.py", "runserver", "0.0.0.0:8000"]