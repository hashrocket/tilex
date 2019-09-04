FROM elixir:1.9.1-alpine as elixir-builder

ENV HOME=/opt/app
WORKDIR $HOME

RUN mix do local.hex --force, local.rebar --force

COPY config/ ./config/
COPY mix.exs mix.lock ./

RUN mix deps.get

###

FROM node:lts-alpine as asset-builder

ENV HOME=/opt/app

WORKDIR $HOME
COPY --from=elixir-builder $HOME/deps $HOME/deps

WORKDIR $HOME/assets
COPY assets/ ./
RUN yarn install
RUN ./node_modules/webpack/bin/webpack.js --mode="production"

###

FROM elixir:1.9.1-alpine

ENV HOME=/opt/app
WORKDIR $HOME

RUN apk --update --no-cache add alpine-sdk coreutils

RUN mix do local.hex --force, local.rebar --force

COPY tilex.env ./tilex.env
COPY config/ $HOME/config/
COPY mix.exs mix.lock $HOME/
COPY lib/ ./lib
COPY priv/ ./priv
COPY entrypoint.sh ./entrypoint.sh

ENV MIX_ENV=prod

RUN mix do deps.get --only $MIX_ENV, deps.compile, compile

COPY --from=asset-builder $HOME/priv/static/ $HOME/priv/static/

RUN mix phx.digest

EXPOSE 4000

CMD ["/opt/app/entrypoint.sh"]
