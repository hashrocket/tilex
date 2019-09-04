#!/bin/sh

source tilex.env
mix ecto.setup
mix phx.digest
exec mix phx.server
