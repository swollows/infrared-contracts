# Get the balance of the LP
cast call 0x4381dC2aB14285160c808659aEe005D51255adD7 "getBalance(address,string)" 0x2D764DFeaAc00390c69985631aAA7Cc3fcfaFAfF dex/cosmos1zq049jqyc8qzczsaxdzzaj3sajm0kfp5cm50sy  --rpc-url https://devnet.beraswillmakeit.com

# Coin to ERC20 transfer
cast send 0x0000000000000000000000000000000000696969 "transferCoinToERC20(string,uint256)" dex/cosmos1zq049jqyc8qzczsaxdzzaj3sajm0kfp5cm50sy 100 --rpc-url https://devnet.beraswillmakeit.com --private-key c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536