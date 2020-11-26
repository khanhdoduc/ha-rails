.SILENT:
.DEFAULT_GOAL := help

COLOR_RESET = \033[0m
COLOR_COMMAND = \033[36m
COLOR_YELLOW = \033[33m
COLOR_GREEN = \033[32m
COLOR_RED = \033[31m

PROJECT := Building Ruby on Rails with HA Architecture on AWS

## Prepare a development environment
plan: prepare

## Installs a development environment
apply: install

## Uninstall a development environment
destroy: uninstall

prepare:
	terraform get -update=true
	terraform init
	terraform plan -out=out.terraform

install:
	terraform apply "out.terraform"

uninstall:
	terraform destroy

## Prints help message
help:
	printf "\n${COLOR_YELLOW}${PROJECT}\n------\n${COLOR_RESET}"
	awk '/^[a-zA-Z\-\_0-9\.%]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "${COLOR_COMMAND}$$ make %s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort
	printf "\n"

## Gen key pair
genkey:
	@read -p "Enter key pair name:" name; \
	ssh-keygen -f $$name
