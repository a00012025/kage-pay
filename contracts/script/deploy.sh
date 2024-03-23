#! /bin/bash

source .env && \
forge script DeployScript --rpc-url "$SEPOLIA_RPC_URL" --verify --etherscan-api-key "$ETHSCAN_API_KEY" --broadcast