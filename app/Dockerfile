FROM mikeifomin/meteor_docker

COPY . app/
WORKDIR /home/meteor/app
RUN ls -lah .
RUN sudo chmod 777 -R . 
RUN meteor npm i
RUN meteor build /home/meteor/

RUN tar -xzf /home/meteor/app.tar.gz -C /home/meteor/
RUN ls -lah /home/meteor/bundle


FROM node:8.8.1


# Error: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by /bundle/prog
# rams/server/npm/node_modules/scrypt/build/Release/scrypt.node)

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

COPY --from=0 /home/meteor/bundle /bundle
WORKDIR /bundle/programs/server
RUN npm install
WORKDIR /bundle

CMD ["node", "main.js"]

