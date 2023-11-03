#!/bin/bash
export PK=c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536 # THE DEFAULT ADMIN PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to deploy the donate caller.
OUTPUT=$(forge script src/script/devnet/Donate.s.sol:DonateScript  --private-key $PK --broadcast --rpc-url=$RPC_URL)
echo "$OUTPUT"  

# Extract contract address.
CONTRACT_ADDRESS=$(echo "$OUTPUT" | awk '/Contract Address:/ {print $3}')
echo "Deployed Factory Contract Address: $CONTRACT_ADDRESS"

# Transfer some honey to the contract.
cast send 0x7EeCA4205fF31f947EdBd49195a7A88E6A91161B "approve(address,uint256)" $CONTRACT_ADDRESS 10000000000000000000000  --private-key $PK --rpc-url=$RPC_URL

# Transfer some usdc to the contract.
cast send 0x1d0f659ff50d1830e449dd88e533cb11fb7a25e4 "approve(address,uint256)" $CONTRACT_ADDRESS 10000000000000000000000  --private-key $PK --rpc-url=$RPC_URL

# Call the donate method on the contract.
cast send $CONTRACT_ADDRESS "donate()"  --private-key $PK --rpc-url=$RPC_URL

