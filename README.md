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

## Dev-Net

### If already deployed (If there is a value in the Configuration.sol AddressesAddress field):
```bash
make log-devnet
```

### Deploy Fresh

```bash
# Deploy to the Berachain Dev Net.
make deploy-devnet

# Deploy to a local Berachain Network.
make deploy-local
```