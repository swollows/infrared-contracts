#!/bin/bash
export PK=010b8742512b091fa10ff09626afbb6dea23f0792992c9bfa9e35cb227fd7df3 # THE KEEPER PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

# Forge script to setup the validators.
OUTPUT=$(forge script src/script/devnet/DeployUsdcHoneyVault.s.sol:DeployUsdcHoneyVault  --private-key $PK --broadcast --rpc-url=$RPC_URL)
echo "$OUTPUT"  
