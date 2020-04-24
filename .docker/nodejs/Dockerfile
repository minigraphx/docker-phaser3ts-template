# specify the node base image with your desired version node:<version>
# at time of creation we have nodejs v14.0, npm v6.14.4
FROM node:latest
# Application Port
EXPOSE 10001
# for installing npm dependencies in user space
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
# optionally if you want to run npm global bin without specifying path
ENV PATH=$PATH:/home/node/.npm-global/bin
# create workdir
WORKDIR /home/node/app
# changing ownership
#RUN chown node .

ADD . /home/node/app
#ADD install.sh /home/node/app
# At the end, set the user to use when running this image
USER node

CMD /bin/bash
#CMD ./.docker/install.sh
#ENTRYPOINT ["/home/node/app/.docker/install.sh"]