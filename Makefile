#!make
include .env

.PHONY: help console outdated setup server test update

.env:
	cp .env.example .env

help: ## Shows this help.
	@grep ": \#" ${MAKEFILE_LIST} | column -t -s ':' | sort

console: ## Opens the App console.
	iex -S mix

outdated: ## Shows outdated packages.
	mix hex.outdated

setup: ## Setup the App.
	mix local.hex --force
	mix setup
	mix gettext.extract --merge --no-fuzzy
	mix usage_rules.sync AGENTS.md --all --inline usage_rules:all --link-to-folder deps

server: ## Start the App server.
	npm install --prefix assets/
	mix phx.server

test: ## Run the test suite.
	mix format
	mix credo
	echo "chromedriver => `chromedriver --version`"
	echo "chrome => `/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version`"
	rm -f screenshots/*
	mkdir -p screenshots/
	mix test --trace

update: ## Update dependencies.
	mix deps.update --all
