// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDCContract is ERC20 {
    constructor() ERC20("USDC", "USDC") {
        _mint(msg.sender, 10000 * 10 ** 18);
    }
}
