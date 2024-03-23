// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/ERC5564Announcer.sol";

contract Deploy5564AnnouncerScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        ERC5564Announcer announcer = new ERC5564Announcer();
        console.logAddress(address(announcer));
        vm.stopBroadcast();
    }
}
