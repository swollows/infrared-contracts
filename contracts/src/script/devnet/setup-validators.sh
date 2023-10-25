#!/bin/bash
export PK=c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536 # THE ADMIN PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to setup the validators.
OUTPUT=$(forge script src/script/devnet/SetupValidators.s.sol:SetupValidators  --private-key $PK --broadcast --rpc-url=$RPC_URL)
echo "$OUTPUT"  
