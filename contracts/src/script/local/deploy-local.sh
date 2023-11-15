#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --rpc-url)
    RPC_URL="$2"
    shift # past argument
    shift # past value
    ;;
    --private-key)
    PRIVATE_KEY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Unknown option: $1"
    exit 1
    ;;
esac
done

# Set default values if not provided
RPC_URL=${RPC_URL:-"http://localhost:8545"}
PRIVATE_KEY=${PRIVATE_KEY:-"0x0000000000000000000000000000000000000000000000000000000000000000"}

# Deploy the IBGT token contract.
IBGT_OUTPUT=$(forge script src/script/local/Deploy.s.sol:DeployIBGT  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
IBGT_ADDRESS=$(echo "$IBGT_OUTPUT" | awk '/Contract Address:/ {print $3}')
echo "Deployed IBGT Contract Address: $IBGT_ADDRESS"
export IBGT_ADDRESS=$IBGT_ADDRESS

# Deploy the Infrared contract.
INFRARED_OUTPUT=$(forge script src/script/local/Deploy.s.sol:DeployInfrared  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
INFRARED_ADDRESS=$(cat broadcast/Deploy.s.sol/2061/run-latest.json | jq -r '.transactions[] | select(.contractName=="Infrared") | .contractAddress')
export INFRARED_ADDRESS=$INFRARED_ADDRESS


# # Configure the Permissions.
PERMISSIONS_OUTPUT=$(forge script src/script/local/Deploy.s.sol:ConfigurePermissions  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
