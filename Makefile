########################################################
#                       Makefile                       #
########################################################
BUILD_TAG ?= devnet-latest
# Default target
all: build

########################################################
#                       Building                       #
########################################################

build: |
	forge build

########################################################
#                       Linting                        #
########################################################

lint-check: |
	npm run lint:check

lint: |
	npm run lint

clean-deps: |
	git submodule deinit --force .
	git submodule update --init --recursive

########################################################
#                        Testing                       #
########################################################

test : |
	forge test -vvvv


########################################################
#                        Dependency                    #
########################################################

setup: |
	@echo "--> Installing Forge dependencies"
	forge install
	git submodule foreach --recursive git clean -xfd
	git submodule foreach --recursive git reset --hard
	git submodule update --init --recursive