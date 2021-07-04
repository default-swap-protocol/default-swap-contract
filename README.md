## Develop Locally

1. Clone this repo and npm install

```bash
  git clone https://github.com/default-swap-protocol/default-swap-contract
  cd default-swap-contract
  npm install
```

2. Create [Alchemy](https://www.alchemy.com/) or [Infura](https://infura.io/) account and get their api key.

3. Add `.env` file

```bash
ALCHEMY_API_KEY = <alchemy_api_key>
INFURA_API_KEY = <infura_api_key>
DEPLOYMENT_ACCOUNT_PRIVATE_KEY = <deployment_account_private_key>
MNEMONIC_WORDS = <mnemonic_words>
WALLET_INITIAL_INDEX = "0"
ETHERSCAN_API_KEY = <etherscan_api_key>
```

You can leave `DEPLOYMENT_ACCOUNT_PRIVATE_KEY` and `ETHERSCAN_API_KEY` empty until you deploy to the mainnet.
I recommend obtaining your mnemonic words from MetaMask and storing in `MNEMONIC_WORDS`.

You are ready to write code!

## Npm Script

`npm run compile`: literally compiles your contracts and generate artifacts and cache.

`npm run deploy:mainnet_forked`: deploys your contracts to the mirrored version of the mainnet in local network.

`npm run node`: runs the default network configured in the `hardhat.config.ts`.

`npm run test`: run test in the test directory.
