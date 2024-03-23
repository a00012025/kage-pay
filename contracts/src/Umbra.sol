// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./IUmbraHookReceiver.sol";

contract Umbra is Ownable {
    // =========================================== Events ============================================

    // Old Announcement
    // /// @notice Emitted when a payment is sent
    // event Announcement(
    //     address indexed receiver, // stealth address
    //     uint256 amount, // funds
    //     address indexed token, // token address or ETH placeholder
    //     bytes32 pkx, // ephemeral public key x coordinate
    //     bytes32 ciphertext // encrypted entropy and payload extension
    // );

    /// @notice Emitted when a token is withdrawn
    event Announcement(
        uint256 indexed schemeId,
        address indexed stealthAddress,
        address indexed caller,
        bytes ephemeralPubKey,
        bytes metadata
    );

    /// @notice Emitted when a token is withdrawn
    event TokenWithdrawal(
        address indexed receiver, // stealth address
        address indexed acceptor, // destination of funds
        uint256 amount, // funds
        address indexed token // token address
    );

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Send and announce an ERC20 payment to a stealth address
     * @param _receiver Stealth address receiving the payment
     * @param _tokenAddr Address of the ERC20 token being sent
     * @param _amount Amount of the token to send, in its own base units
     * @param _pkx X-coordinate of the ephemeral public key used to encrypt the payload
     */
    function sendToken(
        address _receiver,
        address _tokenAddr,
        uint256 _amount,
        bytes32 _pkx // Ephemeral public key x coordinate
    ) external payable {
        // Construct metadata for ERC20 transaction
        bytes memory metadata = abi.encodePacked(
            uint8(0x01),
            uint32(0x0),
            abi.encodePacked(_tokenAddr), // Token contract address
            abi.encodePacked(_amount) // Amount of tokens
        );

        emit Announcement(
            0,
            _receiver,
            msg.sender,
            abi.encodePacked(_pkx),
            metadata
        );

        SafeERC20.safeTransferFrom(
            IERC20(_tokenAddr),
            msg.sender,
            address(this),
            _amount
        );
    }
}
