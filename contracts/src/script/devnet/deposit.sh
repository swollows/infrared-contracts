#!/bin/bash
export PK=c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536 # THE DEFAULT ADMIN PRIVATE KEY
export RPC_URL=https://devnet.beraswillmakeit.com

OUTPUT=$(cast send 0xc70c2FD8f8E3DBbb6f73502C70952f115Bb93929 "approve(address,uint256)" 0x32cfc5EA1dB061dB7d125bC322Afa99BaC7f3384 1000000000000000000 --private-key $PK --rpc-url=$RPC_URL)
echo "$OUTPUT"  


OUTPUT=$(cast send 0x32cfc5EA1dB061dB7d125bC322Afa99BaC7f3384 "deposit(uint256,address)" 1000000000000000000 0x2D764DFeaAc00390c69985631aAA7Cc3fcfaFAfF --private-key $PK --rpc-url=$RPC_URL)
echo "$OUTPUT"  
