.PHONY: setup

setup:
	mix deps.get
	mix compile
	mix ecto.setup
	npm install --prefix assets
