FROM node:4.8.5-stretch

#ENV HTTP_PROXY=docker.for.mac.localhost:3128
#ENV http_proxy=http://docker.for.mac.localhost:3128
#ENV https_proxy=http://docker.for.mac.localhost:3128

#ARG HTTP_PROXY
#RUN [ "x$npm_cache" != "x" ] && ( \ 
    #npm config set proxy http://$npm_cache ;\
    #npm config set https-proxy http://$npm_cache ;\
    #npm config set strict-ssl false \
    #) || true

RUN apt-get update && apt-get install -y --no-install-recommends \
   ca-certificates \ 
   curl \
   git \
   python \
   gcc \
   make \
   build-essential libssl-dev \
   sudo \
   bsdtar

# replace tar due build-time error
RUN ln -sf $(which bsdtar) $(which tar) 


# sudo for meteor install script
RUN useradd -ms /bin/bash meteor
RUN adduser meteor sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER meteor

WORKDIR /home/meteor

ENV RELEASE=1.5.2.2
RUN curl "https://install.meteor.com/?release=${RELEASE}" | sh

COPY app /home/meteor/tmp_app
WORKDIR /home/meteor/tmp_app

USER root
RUN chmod -R 777 /home/meteor/tmp_app
USER meteor
# just for cache
RUN meteor npm i
RUN meteor build --directory /home/meteor/tmp_app_bundle

RUN rm -rf /home/meteor/tmp_app
RUN rm -rf /home/meteor/tmp_app_bundle

WORKDIR /home/meteor
