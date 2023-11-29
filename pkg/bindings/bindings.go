package bindings

// Main Infrared Contracts
//go:generate abigen --pkg infrared --abi ../../contracts/out/Infrared.sol/Infrared.abi.json --out infrared/contract.abigen.go --type Contract

// Infrared Vault Contracts
//go:generate abigen --pkg vault --abi ../../contracts/out/InfraredVault.sol/InfraredVault.abi.json --bin ../../contracts/out/InfraredVault.sol/InfraredVault.bin --out vault/contract.abigen.go --type Contract --alias _supply=Supply1

// Rewards Precompile Contract
//go:generate abigen --pkg rewards --abi ../../contracts/out/Rewards.sol/IRewardsModule.abi.json --out rewards/contract.abigen.go --type Contract
