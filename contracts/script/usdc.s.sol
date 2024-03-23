// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/usdc.sol";

contract DeployUSDCScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        USDCContract usdc = new USDCContract();
        console.logAddress(address(usdc));
        vm.stopBroadcast();
    }
}
