import 'dart:convert';

import 'package:web3dart/web3dart.dart';

class Deployed4337Contract extends DeployedContract {
  Deployed4337Contract(super.abi, super.address);
  static Deployed4337Contract create() {
    return Deployed4337Contract(
      ContractAbi.fromJson(jsonEncode(abi4337), '4337'),
      EthereumAddress.fromHex("0x586b31774d15ee066c95D22A72A5De71eAA95125"),
    );
  }

  ContractEvent get transferEvent => event('transfer');
  ContractEvent get approvalEvent => event('Approval');
  ContractFunction get approve => function('approve');
  ContractFunction get allowance => function('allowance');
  ContractFunction get balanceOf => function('balanceOf');
  ContractFunction get decimals => function('decimals');
  ContractFunction get name => function('name');
  ContractFunction get symbol => function('symbol');
  ContractFunction get totalSupply => function('totalSupply');
  ContractFunction get nonces => function('nonces');
  ContractFunction get transfer => function('transfer');
}

final abi4337 = [
  {
    "inputs": [
      {
        "internalType": "contract IEntryPoint",
        "name": "_entryPoint",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [],
    "name": "accountImplementation",
    "outputs": [
      {"internalType": "contract SimpleAccount", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "owner", "type": "address"},
      {"internalType": "uint256", "name": "salt", "type": "uint256"}
    ],
    "name": "createAccount",
    "outputs": [
      {
        "internalType": "contract SimpleAccount",
        "name": "ret",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "owner", "type": "address"},
      {"internalType": "uint256", "name": "salt", "type": "uint256"}
    ],
    "name": "getAddress",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  }
];
