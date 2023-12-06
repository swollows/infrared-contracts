#!/bin/bash

# How to use this script:
# ./donate.sh --rpc-url https://devnet.beraswillmakeit.com --private-key 0xfffdbb37105441e14b0ee6330d855d8504ff39e705c3afa8f859ac9865f99306 --pool-address 0x101f52c804c1c02c0a1d33442eca30ecb6fb2434 --token0 0x7EeCA4205fF31f947EdBd49195a7A88E6A91161B --token1 0x1d0f659ff50d1830e449dd88e533cb11fb7a25e4 --vault-address 0x70f900bf86c940197089825Fd019C469f61e57e3

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
    --pool-address)
    POOL_ADDRESS="$2"
    shift # past argument
    shift # past value
    ;;
    --token0)
    TOKEN0="$2"
    shift # past argument
    shift # past value
    ;;
    --token1)
    TOKEN1="$2"
    shift # past argument
    shift # past value
    ;;
    --vault-address)
    VAULT_ADDRESS="$2"
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
POOL_ADDRESS=${POOL_ADDRESS:-"0x0000000000000000000000000000000000000000"}
TOKEN0=${TOKEN0:-"0x0000000000000000000000000000000000000000"}
TOKEN1=${TOKEN1:-"0x0000000000000000000000000000000000000000"}
VAULT_ADDRESS=${VAULT_ADDRESS:-"0x0000000000000000000000000000000000000000"}

# Echo out all the values.
echo "RPC_URL: $RPC_URL"
echo "PRIVATE_KEY: $PRIVATE_KEY"
echo "POOL_ADDRESS: $POOL_ADDRESS"
echo "TOKEN0: $TOKEN0"
echo "TOKEN1: $TOKEN1"
echo "VAULT_ADDRESS: $VAULT_ADDRESS"


# Deploy the Donate contract.
DONATE_OUTPUT=$(forge script src/script/Donate.s.sol:DeployDonate  --private-key $PRIVATE_KEY --broadcast --rpc-url=$RPC_URL)
DONATE_ADDRESS=$(echo "$DONATE_OUTPUT" | awk '/Contract Address:/ {print $3}')
echo "Deployed Donate Contract Address: $DONATE_ADDRESS"

# Approve the Donate contract to spend the tokens.
cast send $TOKEN0 "approve(address,uint256)" $DONATE_ADDRESS 10000000000000000000000  --private-key $PK --rpc-url=$RPC_URL
echo "Approved $TOKEN0 to $DONATE_ADDRESS"

cast send $TOKEN1 "approve(address,uint256)" $DONATE_ADDRESS 10000000000000000000000  --private-key $PK --rpc-url=$RPC_URL
echo "Approved $TOKEN1 to $DONATE_ADDRESS"

# Call the donate function.
cast send $DONATE_ADDRESS "donate()"  --private-key $PK --rpc-url=$RPC_URL
echo "Called donate() on $DONATE_ADDRESS"
