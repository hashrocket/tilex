# Build stage
FROM elixir:1.14.1 as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set build ENV
ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy configuration files first
COPY mix.exs mix.lock ./
COPY config config

# Install mix dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy assets directory and install npm dependencies
COPY assets assets
RUN npm install --prefix assets/

# Copy all remaining application files
COPY . .

# Compile assets and digest
RUN mix assets.deploy
RUN mix phx.digest

# Compile the application
RUN mix compile

# Build release
RUN mix release

# Final stage
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy release from builder
COPY --from=builder /app/_build/prod/rel/tilex ./

# Set environment variables
ENV PORT=4000

# Expose port
EXPOSE 4000

# Start the application
CMD ["bin/tilex", "start"]
