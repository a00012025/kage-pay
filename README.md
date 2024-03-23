# kage-pay

## Contracts

### Deploy Contracts

Examples:

1. `./script/deploy.sh -chain=eth-sepolia -contract=account-factory`

1. `./script/deploy.sh -chain=eth-sepolia -contract=erc-5564-announcer`

1. `./script/deploy.sh -chain=eth-sepolia -contract=paymaster`

### Setup Paymaster

1. Update prices from oracle:

   ```bash
   cast send 0xa4Fe52677f2109e1704E765a790619f432BeF959 "updateCachedPrice(bool)" "false" --rpc-url https://public.stackup.sh/api/v1/node/ethereum-sepolia --private-key={PRIVATE_KEY}
   ```

2. Deposit some ether for paymaster to spend:

   ```bash
   cast send 0xa4Fe52677f2109e1704E765a790619f432BeF959 "deposit()" --value 0.1ether --rpc-url https://public.stackup.sh/api/v1/node/ethereum-sepolia --private-key={PRIVATE_KEY}
   ```
