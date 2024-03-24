#!/bin/bash

# Load environment variables
source .env

# Mapping of supported chain names to their environment variable suffixes
declare -A chain_map=(
  ["arbitrum-sepolia"]="ARBITRUM_SEPOLIA"
  ["op-sepolia"]="OP_SEPOLIA"
  ["polygon-mumbai"]="POLYGON_MUMBAI"
  ["scroll-sepolia"]="SCROLL_SEPOLIA"
  ["zircuit"]="ZIRCUIT"
  ["eth-sepolia"]="ETH_SEPOLIA"
  ["linea"]="LINEA_GOERLI"
)

# Check if a chain name is provided
if [ $# -eq 0 ]; then
  echo "No chain name provided."
  echo "Usage: $0 CHAIN_NAME"
  exit 1
fi

chain_name=$1

# Validate the provided chain name
if [[ ! -v chain_map[$chain_name] ]]; then
  echo "Unsupported or invalid chain name: $chain_name"
  exit 1
fi

# Retrieve the environment variable suffix for the specified chain
chain_env_prefix=${chain_map["$chain_name"]}

# Construct the variable names based on the chain name
rpc_url_name="${chain_env_prefix}_RPC_URL"
contract_address_name="${chain_env_prefix}_PAYMASTER_CONTRACT_ADDRESS"

# Dereference the constructed variable names to get their values
rpc_url=${!rpc_url_name}
contract_address=${!contract_address_name}

# Check if the necessary variables are set
if [ -z "$rpc_url" ] || [ -z "$contract_address" ]; then
  echo "RPC URL or Contract Address for $chain_name is not set."
  exit 1
fi

# Execute the cast send commands with the dynamically determined RPC URL and contract address
echo "Setting up Paymaster on $chain_name..."

cast send "$contract_address" "updateCachedPrice(bool)" "false" --rpc-url "$rpc_url" --private-key="$PRIVATE_KEY"
cast send "$contract_address" "deposit()" --value 0.1ether --rpc-url "$rpc_url" --private-key="$PRIVATE_KEY"

echo "Setup for $chain_name completed."