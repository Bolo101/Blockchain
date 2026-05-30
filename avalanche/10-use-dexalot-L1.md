# Use Dexalot L1

In this activity, you interact with an Avalanche L1 for the first time. Dexalot is designed to replicate the user experience of a centralized exchange while preserving the transparency and decentralization of a blockchain system. By using its own Avalanche L1, Dexalot can offer lower fees than many traditional decentralized exchanges while keeping the control and visibility that centralized exchanges lack. [docs.dexalot](https://docs.dexalot.com/en/articles/subnet/)

## Display Dexalot in Core

Before starting, make sure Core Wallet is set to **Testnet mode**, so no real funds are used. Open the Core Wallet browser extension, display all available networks, and star Dexalot so it appears on your home screen. Core is designed to work across multiple chains, which makes switching between networks straightforward. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/03-multi-chain-architecture-intro/06-use-dexalot)

## Bridge Tokens to Dexalot

Next, open the Dexalot Testnet and connect your wallet. To use Dexalot for the first time, you must authenticate your wallet and deposit funds into the Dexalot L1. In the test workflow, you deposit 1 AVAX from the Fuji C-Chain into the Dexalot chain, where it becomes available for trading and other on-chain actions. [youtube](https://www.youtube.com/watch?v=KyN2NpueSg4)

Once the deposit is confirmed, your balances update in the Dexalot dashboard. At this point, the funds are no longer being used on the C-Chain directly; they now live on the Dexalot L1. This is the practical difference between interacting with a custom blockchain and simply using a shared general-purpose chain. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/03-multi-chain-architecture-intro/06-use-dexalot)

## Swap Tokens on Dexalot L1

After depositing, go to the trading interface and swap 0.5 AVAX for USDC. The site will prompt your wallet to switch to the Dexalot L1, and you must confirm that network change before signing the transaction. Once the swap is complete, the updated balances appear in the dashboard. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/03-multi-chain-architecture-intro/06-use-dexalot)

This shows one of the main advantages of an Avalanche L1: the application can run its own trading environment with its own execution rules and token economics, instead of competing for blockspace on a shared chain. Dexalot uses its own L1 to deliver a specialized exchange experience with lower friction for its users. [youtube](https://www.youtube.com/watch?v=a5bCZmlzuCY)

## Withdraw to Fuji C-Chain

Finally, withdraw the AVAX and USDC back to the Fuji C-Chain. From the dashboard, choose the withdrawal option, select the destination network, and confirm the transaction in your wallet. After the withdrawal is processed, the assets return to your Core wallet on the C-Chain. [youtube](https://www.youtube.com/watch?v=KyN2NpueSg4)

## What Happened

At a high level, the workflow demonstrates how Avalanche L1s can be used as specialized application chains. Instead of performing every action on the C-Chain, the assets are bridged to Dexalot, used inside the L1, and then bridged back when needed. This keeps the application logic on a chain optimized for its purpose while preserving interoperability with the broader Avalanche ecosystem. [docs.dexalot](https://docs.dexalot.com/en/articles/subnet/)

Dexalot is a good example of why Avalanche L1s matter: they allow an application to control its own environment, reduce congestion from unrelated activity, and tailor the user experience to a specific use case. [avax](https://www.avax.network/about/blog/dexalot-subnet-earns-avalanche-multiverse-incentives-of-up-to-3-million)