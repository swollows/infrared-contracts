#!/bin/bash

# This system depends on Berachain. The current addresses on local/devnet should be these:

# ###################################### Contracts ######################################
# ERC20BribeModule deployed to: 0x18Df82C7E422A42D47345Ed86B0E935E9718eBda
# Bribe Deployer deployed to: 0x75F950B7DE6a206f58239688AE5F65Bb1a246Cc8
# Pool Deployer deployed to: 0x0EFa8dc7BbAf439095fc690b723c242c3CA36BB1

# ####################################### ERC20s #######################################
# NormalERC20 deployed to: 0x5C59C83c099F72FcE832208f96a23a1E43737a14
# SmallERC20 deployed to: 0x124363b6D0866118A8b6899F2674856618E0Ea4c
# VerySmallERC20 deployed to:
# NormalERC20's denom is: b/0x5C59C83c099F72FcE832208f96a23a1E43737a14
# SmallERC20's denom is: b/0x124363b6D0866118A8b6899F2674856618E0Ea4c
# VerySmallERC20's denom is:

# ####################################### Honey #######################################
# ERC20Honey's address is: 0x7eeca4205ff31f947edbd49195a7a88e6a91161b
# ERC20HoneyModule deployed to: 0x9d76A095a076A565b319f9fc686bc71cFAe9956c

# ####################################### Pools #######################################
# POOL0 (ERC0-ERC1) deployed to: 0x751524e7badd31d018a4caf4e4924a21b0c13cd0
# POOL3 (Honey-STGUSDC) deployed to: 0x101f52c804c1c02c0a1d33442eca30ecb6fb2434
# POOL0's LP denom is: dex/cosmos1w52jfea6m5caqx9yet6wfyj2yxcvz0xs6gtad2
# POOL3's LP denom is: dex/cosmos1zq049jqyc8qzczsaxdzzaj3sajm0kfp5cm50sy

# ###################################### Validators ######################################
# ADDRESS OF VALIDATOR0 is: 0x2ffcd35859dff4344b4ae5d5a1f686108b845817
# CURRENT_EPOCH is: 1

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