#!/bin/bash
export PK=d331822f304b5cb63f23e95cddee0728460f2507ea821889da6cf1cfb9c2dfb9 # THE GOVERNANCE PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to setup the validators.
OUTPUT=$(forge script src/script/devnet/SetupValidators.s.sol:SetupValidators  --private-key $PK --broadcast --rpc-url=$RPC_URL)
echo "$OUTPUT"  
