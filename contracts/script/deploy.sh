#! /bin/bash

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
)

# Flag to indicate dry run mode
dry_run=false

# Check for --dry-run argument and set flag
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    dry_run=true
    break
  fi
done

deploy() {
  chain_readable_name=$1
  chain_env_prefix=${chain_map["$chain_readable_name"]}

  rpc_url_name="${chain_env_prefix}_RPC_URL" # Append _RPC_URL
  api_key_name="${chain_env_prefix}_SCAN_API_KEY" # Append _API_KEY

  rpc_url=${!rpc_url_name}
  api_key=${!api_key_name}

  if [ -z "$rpc_url" ] || [ -z "$api_key" ]; then
    echo "RPC URL or API Key for $chain_readable_name is not set."
    exit 1
  fi

  echo "Deploying to $chain_readable_name..."
  echo ""
  if [ "$dry_run" = true ]; then
    echo "forge script DeployScript --rpc-url \"$rpc_url\" --verify --etherscan-api-key \"$api_key\""
  else
    forge script DeployScript --rpc-url "$rpc_url" --verify --etherscan-api-key "$api_key" --broadcast
  fi
  echo ""
  echo "Deployment to $chain_readable_name completed."
}

# Check if no arguments
if [ $# -eq 0 ]; then
  echo "No chain specified."
  exit 1
fi

# Function to join array elements
join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

# Deploy to specified chain(s)
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    continue # Skip the --dry-run argument
  elif [[ -v chain_map["$arg"] ]]; then
    deploy "$arg"
  elif [[ "$arg" == "all" ]]; then
    for chain_name in "${!chain_map[@]}"; do
      deploy "$chain_name"
    done
  else
    echo "Unsupported chain: $arg. Supported chains are: $(join_by ', ' "${!chain_map[@]}")"
    exit 1
  fi
done