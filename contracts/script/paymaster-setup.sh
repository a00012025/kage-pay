#! /bin/bash

# Load environment variables
source .env

cast send "$PAYMASTER_CONTRACT_ADDRESS" "updateCachedPrice(bool)" "false" --rpc-url https://public.stackup.sh/api/v1/node/ethereum-sepolia --private-key="$PRIVATE_KEY"

cast send "$PAYMASTER_CONTRACT_ADDRESS" "deposit()" --value 0.1ether --rpc-url https://public.stackup.sh/api/v1/node/ethereum-sepolia --private-key="$PRIVATE_KEY"