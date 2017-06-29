# https://hub.docker.com/_/elixir/
FROM elixir:1.4.2

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y postgresql-client inotify-tools

# Install the Phoenix framework itself
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install NodeJS 6.x and the NPM
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q nodejs

# Disable this for development purposes, get a way to re-enable it
# ENV MIX_ENV prod

ADD . /app
RUN mix local.hex --force
RUN mix local.rebar --force
WORKDIR /app
RUN mix do deps.get, compile
RUN cd apps/churchify_web/assets && npm install

EXPOSE 4000

CMD ["mix", "phx.server"]

