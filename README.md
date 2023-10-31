# infrared-mono-repo

## Getting Started

```bash
# Setup the repo contracts and modules
make setup

# Build contracts + binaries
make build

# Build contracts + docker images
make build-docker

# Run smart contract tests 
make test

# Run e2e tests 
make e2e 

# Run the services
make start-services
```

## Deploying on dev-net

```bash
# Deploy the addresses contract. This will keep track of all the contracts deployed.
make deploy-addresses # Copy the output of this script and paste it into the Configurations.sol file.

# Deploy the Infrared contract.
make deploy-infrared

# Setup the validators.
make setup-validators

# Deploy the WIBGT vault.
make deploy-wibgt

# Deploy the USDC-Honey vault.
make deploy-usdc-vault
```