# https://hub.docker.com/_/elixir/
FROM elixir:1.4.5

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y postgresql-client inotify-tools
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
RUN mix local.hex --force
RUN mix local.rebar --force

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q nodejs

RUN mkdir -p /app
WORKDIR /app

COPY . /app
RUN mix deps.get
RUN cd apps/churchify_web/assets && npm install --silent

ENV MIX_ENV prod

EXPOSE 4000

CMD ["mix", "phx.server"]

