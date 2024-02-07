import { store } from "@graphprotocol/graph-ts";
import {
  IBGTSupplied,
  NewVault,
  RewardSupplied,
  ValidatorsAdded,
  ValidatorsRemoved
} from "../generated/Infrared/Infrared";
import { Reward, Validator, Vault } from "../generated/schema";
import { InfraredVault } from "../generated/templates";
import { Infrared } from "../generated/Infrared/Infrared";
import { getID, handleTokens, handleVault } from "./util";

export function handleNewVault(event: NewVault): void {
  InfraredVault.create(event.params._vault); // add as a data source template for the vault.
  handleVault(event);
}

export function handleRewardSupplied(event: RewardSupplied): void {
  const vault = Vault.load(event.params._vault.toHexString());
  if (vault !== null) {
    const tokens = handleTokens([event.params._token]);
    const reward = new Reward(getID(event));
    reward.token = tokens[0].id;
    reward.vault = vault.id;
    reward.amount = event.params._amt.toBigDecimal();
    reward.timestamp = event.block.timestamp;
    reward.txHash = event.transaction.hash;
    reward.caller = event.transaction.from;
    reward.save();
  }
}

export function handleIBGTSupplied(event: IBGTSupplied): void {
  const vault = Vault.load(event.params._vault.toHexString());
  if (vault !== null) {
    const infrared = Infrared.bind(event.address);
    const ibgt = infrared.ibgt();
    const tokens = handleTokens([ibgt]);
    const reward = new Reward(getID(event));
    reward.token = tokens[0].id;
    reward.vault = vault.id;
    reward.amount = event.params._amt.toBigDecimal();
    reward.timestamp = event.block.timestamp;
    reward.txHash = event.transaction.hash;
    reward.caller = event.transaction.from;
    reward.save();
  }
}

export function handleValidatorsAdded(event: ValidatorsAdded): void {
  for (let i = 0; i < event.params._validators.length; i++) {
    const validator = new Validator(event.params._validators[i].toHexString());
    validator.protocol = event.address.toHexString();
    validator.save();
  }
}

export function handleValidatorsRemoved(event: ValidatorsRemoved): void {
  for (let i = 0; i < event.params._validators.length; i++) {
    const validator = Validator.load(event.params._validators[i].toHexString());
    if (validator !== null) {
      store.remove("Validator", validator.id);
    }
  }
}
