#!make
include .env

.PHONY: help outdated console setup server test update

.env:
	cp .env.example .env

help: ## Shows this help.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
	done

outdated: ## Shows outdated packages.
	mix hex.outdated
	npm outdated --prefix assets/

update: ## Bump all hex packages.
	mix deps.updated --all

console:
	iex -S mix

setup: ## Runs the project setup.
	mix local.hex --force
	mix deps.get
	mix compile
	mix ecto.setup
	npm install --prefix assets/

server: ## Starts the server.
	sh .env
	(sleep 3 && open http://localhost:4000/) &
	mix phx.server

test: ## Tests the project.
	mix format
	mix credo
	rm -f screenshots/*
	mix test
