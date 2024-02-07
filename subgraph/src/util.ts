import { ethereum, BigInt } from "@graphprotocol/graph-ts";
import { Address } from "@graphprotocol/graph-ts";
import { Deposit, Token, User, Withdraw } from "../generated/schema";
import { ERC20 } from "../generated/templates/InfraredVault/ERC20";
import { NewVault } from "../generated/Infrared/Infrared";
import { Vault } from "../generated/schema";
import {
  Staked,
  Withdrawn
} from "../generated/templates/InfraredVault/InfraredVault";

export function getID(event: ethereum.Event): string {
  return event.block.number
    .toString()
    .concat("-")
    .concat(event.logIndex.toString());
}

export function handleTokens(tokens: Address[]): Token[] {
  let tokenList: Token[] = [];

  for (let i = 0; i < tokens.length; i++) {
    let token = Token.load(tokens[i].toHexString());

    if (token === null) {
      const contract = ERC20.bind(tokens[i]);
      token = new Token(tokens[i].toHexString());
      token.address = tokens[i];
      token.name = contract.name();
      token.symbol = contract.symbol();
      token.decimals = BigInt.fromI32(contract.decimals());
      token.save();
    }

    tokenList.push(token as Token);
  }
  return tokenList;
}

export function handleVault(event: NewVault): Vault {
  const hexAddress = event.params._vault.toHexString();
  let vault = Vault.load(hexAddress);
  if (vault === null) {
    vault = new Vault(hexAddress);
    vault.pool = event.params._pool;
    handleTokens([event.params._asset]);
    vault.stakingToken = event.params._asset.toHexString();
    vault.rewardTokens = handleTokens(event.params._rewardTokens).map<string>(
      token => token.id
    );
    vault.active = true;
    vault.name = getName(event.params._asset);
    vault.tvl = BigInt.fromI32(0).toBigDecimal();
    vault.save();
  }
  return vault;
}

export function handleUser(address: Address): User {
  let user = User.load(address.toHexString());
  if (user === null) {
    user = new User(address.toHexString());
    user.address = address;
    user.save();
  }

  return user;
}

export function handleStake(event: Staked): Deposit {
  let deposit = Deposit.load(getID(event));
  if (deposit === null) {
    let user = handleUser(event.params.user);
    deposit = new Deposit(getID(event));
    deposit.user = user.id;
    deposit.vault = event.address.toHexString();
    deposit.amount = event.params.amount.toBigDecimal();
    deposit.timestamp = event.block.timestamp;
    deposit.txHash = event.transaction.hash;
    deposit.save();
  }

  updateTvl(event.address);

  return deposit;
}

export function handleWithdraw(event: Withdrawn): Withdraw {
  let withdraw = Withdraw.load(getID(event));
  if (withdraw === null) {
    let user = handleUser(event.params.user);
    withdraw = new Withdraw(getID(event));
    withdraw.user = user.id;
    withdraw.vault = event.address.toHexString();
    withdraw.amount = event.params.amount.toBigDecimal();
    withdraw.timestamp = event.block.timestamp;
    withdraw.txHash = event.transaction.hash;
    withdraw.save();
  }
  updateTvl(event.address);

  return withdraw;
}

export function getName(stakingToken: Address): string {
  let contract = ERC20.bind(stakingToken);
  let name = contract.name();
  return "Infrared " + name + " Vault";
}

export function updateTvl(address: Address): void {
  let vault = Vault.load(address.toHexString());
  if (vault !== null) {
    let contract = ERC20.bind(address);
    vault.tvl = contract.totalSupply().toBigDecimal();
    vault.save();
  }
}
