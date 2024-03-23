import 'dart:convert';

import 'package:app/features/common/constants.dart';
import 'package:web3dart/web3dart.dart';

class Erc5564AnnouncerContract extends DeployedContract {
  Erc5564AnnouncerContract(ContractAbi abi, EthereumAddress address)
      : super(abi, address);
  static Erc5564AnnouncerContract create() {
    return Erc5564AnnouncerContract(
      ContractAbi.fromJson(jsonEncode(erc5564AnnouncerAbi), 'Announcer'),
      Constants.erc5564Announcer,
    );
  }


  ContractFunction get sendToken => function('sendToken');
}

final erc5564AnnouncerAbi = [
  {"inputs": [], "stateMutability": "nonpayable", "type": "constructor"},
  {
    "inputs": [
      {"internalType": "address", "name": "target", "type": "address"}
    ],
    "name": "AddressEmptyCode",
    "type": "error"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "account", "type": "address"}
    ],
    "name": "AddressInsufficientBalance",
    "type": "error"
  },
  {"inputs": [], "name": "FailedInnerCall", "type": "error"},
  {
    "inputs": [
      {"internalType": "address", "name": "owner", "type": "address"}
    ],
    "name": "OwnableInvalidOwner",
    "type": "error"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "account", "type": "address"}
    ],
    "name": "OwnableUnauthorizedAccount",
    "type": "error"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "token", "type": "address"}
    ],
    "name": "SafeERC20FailedOperation",
    "type": "error"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "uint256",
        "name": "schemeId",
        "type": "uint256"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "stealthAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "caller",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "bytes",
        "name": "ephemeralPubKey",
        "type": "bytes"
      },
      {
        "indexed": false,
        "internalType": "bytes",
        "name": "metadata",
        "type": "bytes"
      }
    ],
    "name": "Announcement",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "_receiver", "type": "address"},
      {"internalType": "address", "name": "_tokenAddr", "type": "address"},
      {"internalType": "uint256", "name": "_amount", "type": "uint256"},
      {"internalType": "bytes", "name": "_pk", "type": "bytes"}
    ],
    "name": "sendToken",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "newOwner", "type": "address"}
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];
