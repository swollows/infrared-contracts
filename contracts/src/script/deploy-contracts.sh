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
IBGT_OUTPUT=$(forge script src/script/Deploy.s.sol:DeployIBGT  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
IBGT_ADDRESS=$(echo "$IBGT_OUTPUT" | awk '/Contract Address:/ {print $3}')
echo "Deployed IBGT Contract Address: $IBGT_ADDRESS"
export IBGT_ADDRESS=$IBGT_ADDRESS

# Deploy the Infrared contract.
INFRARED_OUTPUT=$(forge script src/script/Deploy.s.sol:DeployInfrared  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
INFRARED_ADDRESS=$(cat broadcast/Deploy.s.sol/2061/run-latest.json | jq -r '.transactions[] | select(.contractName=="Infrared") | .contractAddress')
export INFRARED_ADDRESS=$INFRARED_ADDRESS


## Configure the Permissions.
forge script src/script/Deploy.s.sol:ConfigurePermissions  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL


## Setup the validators.
forge script src/script/Deploy.s.sol:SetupValidators  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL


## Deploy the WIBGT.
forge script src/script/Deploy.s.sol:DeployWIBGT  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL
WIBGT_ADDRESS=$(cat broadcast/Deploy.s.sol/2061/run-latest.json | jq -r '.transactions[] | select(.contractName=="WrappedIBGT") | .contractAddress')
export WIBGT_ADDRESS=$WIBGT_ADDRESS

## Deploy the WIBGT Vault.
WIBGT_VAULT_OUTPUT=$(forge create src/core/InfraredVault.sol:InfraredVault --private-key $PRIVATE_KEY --rpc-url=$RPC_URL --constructor-args $WIBGT_ADDRESS "Wrapped IBGT Vault" "WIBGT-V" "[$IBGT_ADDRESS]" $INFRARED_ADDRESS $INFRARED_ADDRESS 0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214 0x0000000000000000000000000000000000000069 0x20f33CE90A13a4b5E7697E3544c3083B8F8A51D4)
WIBGT_VAULT_ADDRESS=$(echo "$WIBGT_VAULT_OUTPUT" | grep "Deployed to:" | awk '{print $3}')
export WIBGT_VAULT_ADDRESS=$WIBGT_VAULT_ADDRESS

## Configure the WIBGT vaults.
forge script src/script/Deploy.s.sol:ConfigureWIBGT  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL

## Deploy USDC Vault.
cast send $INFRARED_ADDRESS "registerVault(address,string,string,address[],address)" 0xc70c2FD8f8E3DBbb6f73502C70952f115Bb93929 "USDC-HONEY-VAULT" "UHV" [$IBGT_ADDRESS] 0x101f52c804C1C02c0A1D33442ecA30ecb6fB2434 --rpc-url=$RPC_URL --private-key $PRIVATE_KEY

## Echo out the main addresses.
echo "IBGT_ADDRESS=$IBGT_ADDRESS"
echo "INFRARED_ADDRESS=$INFRARED_ADDRESS"
echo "WIBGT_ADDRESS=$WIBGT_ADDRESS"
echo "WIBGT_VAULT_ADDRESS=$WIBGT_VAULT_ADDRESS"