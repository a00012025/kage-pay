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

# Supported contracts and their deployment scripts
declare -A contract_map=(
  ["erc-5564-announcer"]="Deploy5564AnnouncerScript"
  ["account-factory"]="DeployAccountFactoryScript"
  ["paymaster"]="DeployPaymasterScript"
  ["usdc"]="DeployUSDCScript"
)

# Arrays to store specified chains and contracts
declare -a specified_chains
declare -a specified_contracts

# Flag for dry run mode
dry_run=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -chain=*)
      chain_name="${1#*=}" # Extract everything after "="
      if [[ -v chain_map[$chain_name] ]]; then
        specified_chains+=("$chain_name")
      else
        echo "Invalid chain name: $chain_name"
        exit 1
      fi
      ;;
    -contract=*)
      contract_name="${1#*=}" # Extract everything after "="
      if [[ -v contract_map[$contract_name] ]]; then
        specified_contracts+=("$contract_name")
      else
        echo "Invalid contract name: $contract_name"
        exit 1
      fi
      ;;
    --dry-run)
      dry_run=true
      ;;
    *)
      echo "Unknown or improperly formatted option: $1"
      echo "Use -chain=CHAIN_NAME and -contract=CONTRACT_NAME format."
      exit 1
      ;;
  esac
  shift # Move to the next argument
done

deploy() {
  chain_name=$1
  contract_name=$2
  chain_env_prefix=${chain_map["$chain_name"]}
  deploy_script=${contract_map["$contract_name"]}

  rpc_url_name="${chain_env_prefix}_RPC_URL"
  api_key_name="${chain_env_prefix}_SCAN_API_KEY"

  rpc_url=${!rpc_url_name}
  api_key=${!api_key_name}

  if [ -z "$rpc_url" ] ; then
    echo "RPC URL for $chain_name is not set."
    exit 1
  fi

  if [ -z "$api_key" ]; then
    echo "Etherscan API Key for $chain_name is not set."
    exit 1
  fi

  echo "Deploying $contract_name to $chain_name..."

  # Start composing the command
  cmd="forge script $deploy_script --rpc-url \"$rpc_url\""

  if [ "$chain_name" != "zircuit" ]; then
  cmd="$cmd --verify "
  fi

  cmd="$cmd --etherscan-api-key \"$api_key\" --broadcast"

  # Execute or echo the command based on dry run flag
  if [ "$dry_run" = true ]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi

  echo "Deployment to $chain_name completed."
}

# Validate input
if [ ${#specified_chains[@]} -eq 0 ] || [ ${#specified_contracts[@]} -eq 0 ]; then
  echo "Please specify at least one chain and one contract. Example usage:"
  echo "  $0 -chain=arbitrum-sepolia -contract=erc-5564-announcer --dry-run"
  exit 1
fi

# Deploy to specified chains and contracts
for chain in "${specified_chains[@]}"; do
  for contract in "${specified_contracts[@]}"; do
    deploy "$chain" "$contract"
  done
done