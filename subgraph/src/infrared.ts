import { store } from "@graphprotocol/graph-ts";
import { IBGTSupplied, NewVault, RewardSupplied, ValidatorsAdded, ValidatorsRemoved } from "../generated/Infrared/Infrared";
import { IBGTReward, Infrared, Reward, Validator, Vault } from "../generated/schema";
import { InfraredVault } from "../generated/templates";
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
      reward.save();
   }
}


export function handleIBGTSupplied(event: IBGTSupplied): void {
   const vault = Vault.load(event.params._vault.toHexString());
   if (vault !== null) {
      const ibgtReward = new IBGTReward(getID(event));
      ibgtReward.vault = vault.id;
      ibgtReward.amount = event.params._amt.toBigDecimal();
      ibgtReward.timestamp = event.block.timestamp;
      ibgtReward.save();
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
         store.remove('Validator', validator.id);
      }
   }
}