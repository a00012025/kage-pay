// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/SimpleAccountFactory.sol";

contract DeployAccountFactoryScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        IEntryPoint entrypoint = IEntryPoint(
            0x0000000071727De22E5E9d8BAf0edAc6f37da032
        );
        SimpleAccountFactory factory = new SimpleAccountFactory(entrypoint);

        // Log factory address
        console.logAddress(address(factory));

        vm.stopBroadcast();
    }
}
