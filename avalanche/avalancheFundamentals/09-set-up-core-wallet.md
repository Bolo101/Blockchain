# Set Up Core Wallet

To better understand the concept of Avalanche L1s, we will interact with a chain. To do that, we will use **Core**, an all-in-one command center built for multi-chain systems. Core supports Avalanche, Bitcoin, Ethereum, and all EVM-compatible blockchains. It is available as a browser extension, a web wallet, and a mobile app, and it is optimized for multiple chains, making navigation between them easy. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/03-multi-chain-architecture-intro/05-setup-core)

## Installation Steps

### 1. Install the Core Extension

The Core extension is compatible with Google Chrome. Go to the Chrome Web Store and add it to your browser:

- **Core Crypto Wallet & NFT Extension**

After installation, make sure to pin the extension to your browser toolbar, since you will use it frequently in the coming courses. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/03-multi-chain-architecture-intro/04-setup-core)

### 2. Create a Wallet

Open the Core extension and follow the instructions to create a new wallet. You can either click **Continue with Google** or manually create a new wallet by following the steps in Core. Since we will be handling only valueless testnet tokens, you do not need to use cold storage (such as a Ledger) at this stage. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/04-creating-an-l1/02-connect-core)

### 3. Switch to Testnet Mode

Since we do not want to work with real funds, we will switch to the **Fuji Testnet**, an exact replica of Avalanche's Mainnet architecture, except that its tokens are valueless.

To enable Testnet Mode, open the Core browser extension, click the burger menu, go to **Advanced**, and activate **Testnet Mode**. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/03-multi-chain-architecture-intro/05-setup-core)

### 4. Get Testnet Tokens

With a Builder Hub account and a connected wallet, you will automatically receive testnet tokens on the C-Chain, P-Chain, Dispatch, Echo, and other supported L1s. No coupon codes are needed.

**How it works:**

- Create a Builder Hub account (if you haven't already).
- Connect your Core wallet.
- Tokens are automatically sent to your wallet when needed.

Alternatively, you can use the **Avalanche Testnet Faucet** to get free testnet AVAX, ALOT, and USDC. Some faucets may require a coupon code such as `avalanche-academy`. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/03-multi-chain-architecture-intro/04-setup-core)

## Managing MetaMask and Core Extensions

If you already have MetaMask installed, you may encounter conflicts between the two wallet extensions. You do not need to uninstall MetaMask; you can simply disable it temporarily.

### Steps to Disable MetaMask

1. Open the extensions page in your browser. You can also type `chrome://extensions` in your address bar.
2. Scroll through your list of installed extensions or use the search bar to find the MetaMask extension.
3. Click the toggle switch next to MetaMask to disable it.

When the switch is in the off position, MetaMask is disabled and you should be all set. You can re-enable it at any time. [academy.avax](https://academy.avax.network/course/archive/06-setup-core-wallet)

## Why Core Wallet for Avalanche L1s

Core is the native wallet for Avalanche and is currently the only wallet that supports issuing P-Chain transactions, which are required for validator coordination and staking. This is why other wallets such as MetaMask or Rabby cannot be used for certain Avalanche L1 operations. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/04-creating-an-l1/02-connect-core)

For developers and users working with Avalanche L1s, Core provides the necessary support for multi-chain navigation, cross-chain messaging, and P-Chain operations needed to launch and manage custom blockchains.