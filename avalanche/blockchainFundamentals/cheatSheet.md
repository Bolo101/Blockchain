Programs and apps are software applications designed to run on different types of computers, such as smartphones, PCs, and web servers. On smartphones, apps are typically designed for specific tasks like messaging, gaming, or social media, optimized for touch interfaces and mobile connectivity. PCs run more complex programs, such as word processors, video editors, or development tools, which take advantage of larger screens, more powerful hardware, and the ability to handle multitasking. Web servers, on the other hand, run server-side applications that power websites, process data, and handle multiple user requests simultaneously. These programs often provide the backend services that apps on smartphones and PCs rely on to function.



Similarly, smart contracts or decentralized applications (dApps) are programs that run on a blockchain. A smart contract is a self-executing program with the terms of the agreement directly written into code, operating without the need for a trusted central authority. dApps are more complex, often consisting of multiple smart contracts that together offer a full application experience on the blockchain. Like traditional apps, these blockchain-based programs can perform a wide range of tasks, from managing digital assets to running decentralized finance (DeFi) protocols.



Different types of applications can interoperate across these platforms, enabling a seamless user experience. For instance, a mobile app can interact with a backend running on a web server to fetch or update data. Similarly, the same app could also interact with a smart contract on a blockchain to verify transactions or access decentralized services. This interoperability allows users to benefit from the strengths of each platform, combining the user-friendliness of mobile apps, the processing power of web servers, and the security and transparency of blockchain technology.

Explore the unique advantages and challenges of blockchain technology in finance, supply chain management, and voting systems. Learn how blockchain enhances security, transparency, and decentralization, while also considering its limitations in efficiency and complexity.

Blockchains have unique properties that make them an excellent fit for certain use cases where security, transparency, and decentralization are paramount:

Finance
Blockchains enable secure, transparent transactions without the need for intermediaries. This is the foundation of cryptocurrencies and decentralized finance (DeFi) platforms. The immutability of blockchain records ensures that financial transactions are tamper-proof and can be audited at any time, making it ideal for high-stakes environments where trust is critical.

Supply Chain Management
Blockchain can provide an immutable record of a product's journey from origin to consumer, increasing transparency and reducing fraud. This helps ensure that every step of the supply chain is accurately tracked and verified.

Voting Systems
Blockchain's transparency and security ensure that votes are accurately counted and cannot be altered. This is crucial for maintaining democratic integrity and building trust in electoral processes.

Knowledge check
Question 1 of 2
The content lists finance, supply chain management, and voting systems as excellent use cases for blockchain. What do these three applications have in common that makes blockchain particularly well-suited for them? (Select all that apply)

The common thread across these use cases is the critical need for trust, transparency, and immutable records. In finance, participants need confidence that transactions are tamper-proof and auditable. In supply chain management, multiple parties need to trust that product journey records are accurate and unaltered. In voting systems, democratic integrity requires verifiable, unchangeable vote records that everyone can trust. Blockchain addresses the fundamental trust problem in these scenarios by providing cryptographic proof of transactions, transparent verification, and immutability - eliminating the need to trust a central authority. The content explicitly states blockchain provides 'immutability' that 'ensures that financial transactions are tamper-proof and can be audited at any time.'

Downsides
However, the same properties that make blockchains so powerful in these areas also introduce significant challenges. Blockchains are inherently less efficient than traditional databases because they require consensus among distributed nodes, which can slow down transaction speeds and increase the complexity of operations. This makes blockchain less suitable for use cases where high speed and efficiency are critical, such as real-time data processing or high-frequency trading. Additionally, the complexity of developing and maintaining blockchain systems can be a barrier, particularly for applications that don't require the levels of security and decentralization that blockchains offer.

When deciding whether to use blockchain, consider whether your use case requires the specific advantages of decentralization, transparency, and security. Blockchain is well-suited for applications where trust between parties is a major concern and where an immutable record of transactions is essential. However, if your application demands high throughput, real-time processing, or simplicity, a traditional centralized system might be more appropriate. In short, blockchain is a powerful tool for the right situations, but its use should be carefully considered against the specific needs of your application.

Knowledge check
Question 2 of 2
According to the content, when should you NOT use blockchain for your application?

The decision to use blockchain should be driven by specific requirements, not hype. Blockchain is powerful but comes with trade-offs - it's slower and more complex than traditional databases. If your application needs real-time processing (like high-frequency trading), maximum throughput, or simple implementation, and if the problem doesn't involve trust between multiple parties or need for immutable records, then a traditional centralized system is more appropriate. As the content emphasizes: 'blockchain is a powerful tool for the right situations, but its use should be carefully considered against the specific needs of your application.' Just because blockchain provides security doesn't mean every secure application needs it - centralized databases can also be secure and are often more efficient.

Payments Use Case
Explore how blockchain technology can revolutionize payments by building decentralized systems. This chapter delves into account balances, transactions, and user interactions, highlighting the benefits of blockchain for security, transparency, and decentralization. Discover how these concepts apply to various use cases beyond payments, including decentralized finance, voting systems, and supply chain management.

In this chapter we will dive deeper in the payments use case. We will explore how blockchain technology can be used to build a decentralized payment system. We will look at the different components of a payment system, such as account balances, transactions, and user interactions. We will also discuss the benefits of using blockchain technology for payments, such as security, transparency, and decentralization.

Use Case	Data Structures	User Interactions
Payments	Account Balances	Transfer Funds
Decentralized Finance	Loans, ...	Borrow, Repay, ..
Voting Systems	Votes	Vote
Supply Chain	Shipments	Hand Over, Deliver
Identity Management	Certificates	Issue, Proof
Many of the concepts we will discuss in this chapter are applicable to other use cases as well. For example, the idea of account balances and transactions is not unique to payments but can be found in other applications like decentralized finance (DeFi) or supply chain management. Similarly, user interactions such as transferring funds or voting can be applied to various use cases, each with its unique requirements and challenges.

So while we are discussing this specific use case, try to think about how these concepts could be adapted to other scenarios. This will help you understand the broader implications of blockchain technology and how it can be used to solve a wide range of problems across different industries and domains.

Account Balances & Transfers
Learn about account balances, which reflect the current amount of money or assets in an account after credits and debits. Discover how transfers work by moving funds between accounts, ensuring balance integrity across financial systems.

Account Balances
Account Balances refer to the current amount of money or assets held in a specific account at a given time. This number reflects the total value after all credits (additions) and debits (subtractions) have been accounted for, indicating how much the account holder has available to use or withdraw. For example, in a bank account, the balance represents the amount of money that the account holder can access, whether for spending, saving, or transferring.



Transfers
A Transfer is the process of moving money or assets from one account to another. During a transfer, the balance of the sending account is reduced by the amount being transferred, while the balance of the receiving account is increased by the same amount. This operation ensures that the total value across all accounts remains constant, maintaining the integrity of the overall financial system.



Invalid Transfers
An invalid transfer occurs when a transaction request exceeds the available balance in the sending account. In such cases, the transfer cannot be executed, and the system will reject the transaction to prevent overdrafts. As a result, both the sending and receiving account balances remain unchanged, preserving the integrity of the financial records. This safeguard ensures that accounts do not inadvertently fall into negative balances and maintains accurate and reliable financial tracking.

Ledger
Understand the high-level structure of this chapter.

A ledger is a comprehensive record-keeping system that documents all transactions. It maintains a detailed and chronological list of transactions, capturing every transfers across accounts. This ensures that every action is accurately tracked and traceable, providing a clear and complete view of the system's activity.



Immutability
An immutable ledger means that once a transaction is recorded, it cannot be altered or deleted. This immutability ensures that the historical record of all transactions remains intact and unchangeable, which is crucial for maintaining transparency and trust. Even if errors are made or transactions are invalid, the ledger preserves the original data, preventing tampering or unauthorized modifications.

Append-Only
An append-only ledger operates by adding new transactions to the end of the record without altering any previous entries. This means that while the ledger grows with each new transaction, past transactions remain unchanged and preserved. Invalid transactions, which fail to execute due to issues like insufficient funds, are still recorded in the ledger to maintain a complete history. To reverse the effects of a transaction, a new transaction must be appended that counteracts the previous one, ensuring the integrity and consistency of the ledger's overall state.