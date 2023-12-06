#!/bin/bash

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --rpc-url)
        rpc_url="$2"
        shift
        shift
        ;;
        --private-key)
        private_key="$2"
        shift
        shift
        ;;
        --infrared)
        infrared="$2"
        shift
        shift
        ;;
        --asset)
        asset="$2"
        shift
        shift
        ;;
        --name)
        name="$2"
        shift
        shift
        ;;
        --symbol)
        symbol="$2"
        shift
        shift
        ;;
        --reward-tokens)
        reward_tokens="$2"
        shift
        shift
        ;;
        --pool-address)
        pool_address="$2"
        shift
        shift
        ;;
        *)
        echo "Unknown option: $1"
        shift
        ;;
    esac
done


# Example usage of the arguments
echo "RPC URL: $rpc_url"
echo "Private Key: $private_key"
echo "Infrared: $infrared"
echo "Asset: $asset"
echo "Name: $name"
echo "Symbol: $symbol"
echo "Reward Tokens: $reward_tokens"
echo "Pool Address: $pool_address"

# Call to the register function on the Infrared contract.
cast send $infrared "registerVault(address,string,string,address[],address)" $asset $name $symbol $reward_tokens $pool_address --rpc-url=$rpc_url --private-key $private_key