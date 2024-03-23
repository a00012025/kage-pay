import 'dart:convert';

import 'package:app/features/common/constants.dart';
import 'package:web3dart/web3dart.dart';

class SimpleAccountFactoryContract extends DeployedContract {
  SimpleAccountFactoryContract(super.abi, super.address);
  static SimpleAccountFactoryContract create() {
    return SimpleAccountFactoryContract(
      ContractAbi.fromJson(jsonEncode(factoryContractAbi), 'factory_contract'),
      Constants.simpleAccountFactory,
    );
  }

//
//   ContractEvent get transferEvent => event('transfer');
//   ContractEvent get approvalEvent => event('Approval');
//   ContractFunction get approve => function('approve');
//   ContractFunction get allowance => function('allowance');
//   ContractFunction get balanceOf => function('balanceOf');
//   ContractFunction get decimals => function('decimals');
//   ContractFunction get name => function('name');
//   ContractFunction get symbol => function('symbol');
//   ContractFunction get totalSupply => function('totalSupply');
//   ContractFunction get nonces => function('nonces');
//   ContractFunction get transfer => function('transfer');
  ContractFunction get getAddress => function('getAddress');
  ContractFunction get accountImplementation =>
      function('accountImplementation');
}

final factoryContractAbi = [
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
      {
        "internalType": "address",
        "name": "paymasterTokenAddress",
        "type": "address"
      },
      {"internalType": "address", "name": "paymaster", "type": "address"},
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
      {
        "internalType": "address",
        "name": "paymasterTokenAddress",
        "type": "address"
      },
      {"internalType": "address", "name": "paymaster", "type": "address"},
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
