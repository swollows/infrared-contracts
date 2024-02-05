import {
  Staked,
  Withdrawn
} from "../generated/templates/InfraredVault/InfraredVault";
import { getID, handleStake, handleUser, handleWithdraw } from "./util";

export function handleStaked(event: Staked): void {
  handleStake(event);
}

export function handleWithdrawn(event: Withdrawn): void {
  handleWithdraw(event);
}
