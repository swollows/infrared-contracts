########################################################
#                       Makefile                       #
########################################################
BUILD_TAG ?= devnet-latest
# Default target
all: build


########################################################
#                         Setup                        #
########################################################

# Generate versioning information
TAG_COMMIT := $(shell git rev-list --abbrev-commit --tags --max-count=1)
TAG := $(shell git describe --abbrev=0 --tags ${TAG_COMMIT} 2>/dev/null || true)
COMMIT := $(shell git rev-parse --short HEAD)
DATE := $(shell git log -1 --format=%cd --date=format:"%Y%m%d")
VERSION := $(TAG:v%=%)
ifneq ($(COMMIT), $(TAG_COMMIT))
    VERSION := $(VERSION)-next-$(COMMIT)-$(DATE)
endif
ifneq ($(shell git status --porcelain),)
    VERSION := $(VERSION)-dirty
endif

########################################################
#                       Building                       #
########################################################

# List of services names
DIR_NAMES := api indexer

# Build all services
build-%:
	@echo Building infrared-mono-repo-$*
	@go build -o bin/infrared-mono-repo-$* services/$*/cmd/main.go

# Target for building the application in all directories
build: \
	$(patsubst %, build-%, $(DIR_NAMES)) 
	@echo Building infrared-contracts
	@echo Installing husky
	forge build --extra-output-files bin --extra-output-files abi --root ./contracts

# Generate solidity bindings for the infrared contracts
bindings: 
	forge build --extra-output-files bin --extra-output-files abi --root ./contracts
	cd pkg/bindings && go generate ./...

# Generate protobuf files
proto-gen:
	buf generate proto
	
# Format the contracts (TODO add go formatting)
forge-lint-check: |
	npm run lint:check

forge-lint: |
	npm run lint

########################################################
#                       Linting                        #
########################################################

lint: |
	@$(MAKE) golangci-fix forge-lint gosec

########################################################
#                        Testing                       #
########################################################

test : |
	forge test -vvvv --root ./contracts

start: |
	docker-compose -f testutil/docker-compose.yml up

startd: 
	docker-compose -f testutil/docker-compose.yml up -d

stop: |
	docker-compose -f testutil/docker-compose.yml down

########################################################
#                        Dependency                    #
########################################################

setup: |
	@echo "--> Installing Forge dependencies"
	forge install --root ./contracts
	git submodule foreach --recursive git clean -xfd
	git submodule foreach --recursive git reset --hard
	git submodule update --init --recursive

#################
# golangci-lint #
#################

golangci_version=v1.54.2

golangci-install:
	@echo "--> Installing golangci-lint $(golangci_version)"
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@$(golangci_version)

golangci:
	@$(MAKE) golangci-install
	@echo "--> Running linter"
	@go list -f '{{.Dir}}/...' -m | xargs golangci-lint run  --timeout=10m --concurrency 8 -v 

golangci-fix:
	@$(MAKE) golangci-install
	@echo "--> Running linter"
	@go list -f '{{.Dir}}/...' -m | xargs golangci-lint run  --timeout=10m --fix --concurrency 8 -v 

#################
#     gosec     #
#################

gosec-install:
	@echo "--> Installing gosec"
	@go install github.com/securego/gosec/v2/cmd/gosec@latest

gosec:
	@$(MAKE) gosec-install
	@echo "--> Running gosec"
	@gosec -exclude-generated ./...


########################################################
#                        Services                      #
########################################################

start-services:
	@echo "--> Starting all services"
	@$(MAKE) start-indexer

start-indexer:
	@echo "--> Starting indexer"
	go run services/indexer/cmd/main.go start --config-path services/indexer/config.toml


########################################################
#                        Dev-Net                       #
########################################################

deploy-all: |
	@$(MAKE) deploy-infrared setup-validators


deploy-addresses:
	@echo "--> Deploying addresses"
	cd contracts && src/script/devnet/deploy-addresses.sh

deploy-infrared:
	@echo "--> Deploying infrared"
	cd contracts && src/script/devnet/deploy-infrared.sh

setup-validators:
	@echo "--> Setting up validators"
	cd contracts && src/script/devnet/setup-validators.sh

deploy-wibgt:
	@echo "--> Deploying wibgt vault"
	cd contracts && src/script/devnet/deploy-wibgt-vault.sh

deploy-usdc-vault:
	@echo "--> Deploying usdc-honey vault"
	cd contracts && src/script/devnet/deploy-usdc-pool.sh

deposit:
	@echo "--> Depositing usdc-honey lp"
	cd contracts && src/script/devnet/deposit.sh

donate:
	@echo "--> Donating wibgt"
	cd contracts && src/script/devnet/donate.sh
	
log-devnet:
	@echo "--> Logging devnet"
	cd contracts && src/script/devnet/get-addresses.sh