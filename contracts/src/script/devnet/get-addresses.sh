#!/bin/bash
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to get the all the addresses
OUTPUT=$(forge script src/script/devnet/GetAddresses.s.sol:GetAddresses --rpc-url=$RPC_URL)
echo "$OUTPUT"  