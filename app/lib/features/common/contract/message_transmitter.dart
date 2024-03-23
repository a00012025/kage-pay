import 'dart:convert';
import 'package:web3dart/web3dart.dart';

class MessageTransmitterContract extends DeployedContract {
  MessageTransmitterContract(EthereumAddress address)
      : super(ContractAbi.fromJson(jsonEncode(msgAbi), 'MessageTransmitter'),
            address);

  ContractEvent get messageSentEvent => event('MessageSent');
  ContractFunction get receiveMessage => function('receiveMessage');
}

final msgAbi = [
  {
    "inputs": [
      {"internalType": "uint32", "name": "_localDomain", "type": "uint32"},
      {"internalType": "address", "name": "_attester", "type": "address"},
      {
        "internalType": "uint32",
        "name": "_maxMessageBodySize",
        "type": "uint32"
      },
      {"internalType": "uint32", "name": "_version", "type": "uint32"}
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "attester",
        "type": "address"
      }
    ],
    "name": "AttesterDisabled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "attester",
        "type": "address"
      }
    ],
    "name": "AttesterEnabled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousAttesterManager",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newAttesterManager",
        "type": "address"
      }
    ],
    "name": "AttesterManagerUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "newMaxMessageBodySize",
        "type": "uint256"
      }
    ],
    "name": "MaxMessageBodySizeUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "caller",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint32",
        "name": "sourceDomain",
        "type": "uint32"
      },
      {
        "indexed": true,
        "internalType": "uint64",
        "name": "nonce",
        "type": "uint64"
      },
      {
        "indexed": false,
        "internalType": "bytes32",
        "name": "sender",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "internalType": "bytes",
        "name": "messageBody",
        "type": "bytes"
      }
    ],
    "name": "MessageReceived",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "bytes",
        "name": "message",
        "type": "bytes"
      }
    ],
    "name": "MessageSent",
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
    "name": "OwnershipTransferStarted",
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
  {"anonymous": false, "inputs": [], "name": "Pause", "type": "event"},
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "newAddress",
        "type": "address"
      }
    ],
    "name": "PauserChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "newRescuer",
        "type": "address"
      }
    ],
    "name": "RescuerChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "oldSignatureThreshold",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "newSignatureThreshold",
        "type": "uint256"
      }
    ],
    "name": "SignatureThresholdUpdated",
    "type": "event"
  },
  {"anonymous": false, "inputs": [], "name": "Unpause", "type": "event"},
  {
    "inputs": [],
    "name": "acceptOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "attesterManager",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "attester", "type": "address"}
    ],
    "name": "disableAttester",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "newAttester", "type": "address"}
    ],
    "name": "enableAttester",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "index", "type": "uint256"}
    ],
    "name": "getEnabledAttester",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getNumEnabledAttesters",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "attester", "type": "address"}
    ],
    "name": "isEnabledAttester",
    "outputs": [
      {"internalType": "bool", "name": "", "type": "bool"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "localDomain",
    "outputs": [
      {"internalType": "uint32", "name": "", "type": "uint32"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "maxMessageBodySize",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "nextAvailableNonce",
    "outputs": [
      {"internalType": "uint64", "name": "", "type": "uint64"}
    ],
    "stateMutability": "view",
    "type": "function"
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
    "name": "pause",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "paused",
    "outputs": [
      {"internalType": "bool", "name": "", "type": "bool"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "pauser",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "pendingOwner",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "bytes", "name": "message", "type": "bytes"},
      {"internalType": "bytes", "name": "attestation", "type": "bytes"}
    ],
    "name": "receiveMessage",
    "outputs": [
      {"internalType": "bool", "name": "success", "type": "bool"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "bytes", "name": "originalMessage", "type": "bytes"},
      {"internalType": "bytes", "name": "originalAttestation", "type": "bytes"},
      {"internalType": "bytes", "name": "newMessageBody", "type": "bytes"},
      {
        "internalType": "bytes32",
        "name": "newDestinationCaller",
        "type": "bytes32"
      }
    ],
    "name": "replaceMessage",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "contract IERC20",
        "name": "tokenContract",
        "type": "address"
      },
      {"internalType": "address", "name": "to", "type": "address"},
      {"internalType": "uint256", "name": "amount", "type": "uint256"}
    ],
    "name": "rescueERC20",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "rescuer",
    "outputs": [
      {"internalType": "address", "name": "", "type": "address"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint32", "name": "destinationDomain", "type": "uint32"},
      {"internalType": "bytes32", "name": "recipient", "type": "bytes32"},
      {"internalType": "bytes", "name": "messageBody", "type": "bytes"}
    ],
    "name": "sendMessage",
    "outputs": [
      {"internalType": "uint64", "name": "", "type": "uint64"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint32", "name": "destinationDomain", "type": "uint32"},
      {"internalType": "bytes32", "name": "recipient", "type": "bytes32"},
      {
        "internalType": "bytes32",
        "name": "destinationCaller",
        "type": "bytes32"
      },
      {"internalType": "bytes", "name": "messageBody", "type": "bytes"}
    ],
    "name": "sendMessageWithCaller",
    "outputs": [
      {"internalType": "uint64", "name": "", "type": "uint64"}
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "newMaxMessageBodySize",
        "type": "uint256"
      }
    ],
    "name": "setMaxMessageBodySize",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "newSignatureThreshold",
        "type": "uint256"
      }
    ],
    "name": "setSignatureThreshold",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "signatureThreshold",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
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
  },
  {
    "inputs": [],
    "name": "unpause",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newAttesterManager",
        "type": "address"
      }
    ],
    "name": "updateAttesterManager",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "_newPauser", "type": "address"}
    ],
    "name": "updatePauser",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "newRescuer", "type": "address"}
    ],
    "name": "updateRescuer",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "bytes32", "name": "", "type": "bytes32"}
    ],
    "name": "usedNonces",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "version",
    "outputs": [
      {"internalType": "uint32", "name": "", "type": "uint32"}
    ],
    "stateMutability": "view",
    "type": "function"
  }
];
