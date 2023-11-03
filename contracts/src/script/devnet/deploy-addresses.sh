#!/bin/bash
export PK=c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536 # THE ADMIN PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to deploy the addresses contract
OUTPUT=$(forge script src/script/devnet/Addresses.sol:DeployAddresses --private-key $PK --broadcast --rpc-url=$RPC_URL)
echo "$OUTPUT"  


# Extract contract address
CONTRACT_ADDRESS=$(echo "$OUTPUT" | awk '/Contract Address:/ {print $3}')

echo  -e "${GREEN} Contract Address: $CONTRACT_ADDRESS Add this to the Configuration.sol before running the other scripts."


















