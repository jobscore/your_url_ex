FROM elixir:1.6.1
RUN cd /tmp \
  && curl -sL https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz -o node.tar.xz \
  && tar xf node.tar.xz \
  && cp -RT ./node*/ /usr/local/ \
  && rm -rf /tmp/node* && mkdir -p /var/log/phoenix

WORKDIR /app
ENV AUTHORIZATION_TOKEN_SALT="YourUrlTokenSalt"
ENV SECRET_KEY_BASE="SuperS3cretKeyB@se"
ENV MIX_ENV=prod
ENV DB_USER=postgres
ENV DB_PASS=password
ENV DB_NAME=your-urls-ex
ENV DB_HOST=db
ENV REDIS_HOST=redis

# Install Elixir Deps
ADD mix.* ./
RUN mix local.rebar && mix local.hex --force
RUN mix deps.get

# Install Node Deps
ADD package.json ./
RUN npm install

# Install app
ADD . .
RUN mix compile

# Compile assets
RUN NODE_ENV=production node_modules/brunch/bin/brunch build --production
RUN mix phoenix.digest

# Exposes this port from the docker container to the host machine
EXPOSE 4000
