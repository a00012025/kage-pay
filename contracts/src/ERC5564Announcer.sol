// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC5564Announcer is Ownable {
    /// @notice Emitted when a token is withdrawn
    event Announcement(
        uint256 indexed schemeId,
        address indexed stealthAddress,
        address indexed caller,
        bytes ephemeralPubKey,
        bytes metadata
    );

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Send and announce an ERC20 payment to a stealth address
     * @param _receiver Stealth address receiving the payment
     * @param _tokenAddr Address of the ERC20 token being sent
     * @param _amount Amount of the token to send, in its own base units
     * @param _pk X and Y coordinate of the ephemeral public key used to encrypt the payload
     */
    function sendToken(
        address _receiver,
        address _tokenAddr,
        uint256 _amount,
        bytes calldata _pk
    ) external {
        // Construct metadata for ERC20 transaction
        bytes memory metadata = abi.encodePacked(
            uint8(0x01),
            uint32(0x0),
            abi.encodePacked(_tokenAddr), // Token contract address
            abi.encodePacked(_amount) // Amount of tokens
        );

        emit Announcement(0, _receiver, msg.sender, _pk, metadata);

        SafeERC20.safeTransferFrom(
            IERC20(_tokenAddr),
            msg.sender,
            _receiver,
            _amount
        );
    }
}
