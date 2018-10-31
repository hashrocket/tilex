FROM elixir:1.6-alpine

ENV APP_HOME=/app

# Install Node.js and dependencies needed for installing Phoenix.
ENV PACKAGES="git \
  nodejs \
  nodejs-npm \
  build-base \
"
RUN apk add --update ${PACKAGES}

# Install Phoenix.
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Setup home for application.
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN addgroup -S til && \
  adduser -S -G til til && \
  chown --recursive til:til $APP_HOME

# Run everything as the til user now.
USER til

# Install app depednencies
RUN mix local.hex --force && \
  mix deps.get --force && \
  mix local.rebar --force && \
  npm install --prefix assets

ENTRYPOINT [ "mix", "ecto.setup", "--force" ]

CMD [ "mix", "phx.server" ]
