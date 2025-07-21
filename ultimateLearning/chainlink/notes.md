# Solidity


## Value type

Value types store their data directly when you assign a value type to another variable, you get a copy of the value.
This happens because value types (like integers, booleans, addresses, etc.) store their actual data directly in the variable. Each variable has its own separate copy of the data.


## Reference type

In Solidity, reference types (arrays, structs, strings, and mappings) are stored as pointers. When you pass these types around, Solidity doesn't copy all the data; it just references where the data is stored.

- storage: Permanent storage on the blockchain (expensive)

Used for state variables.

Data persists between function calls and transactions.

Most expensive in terms of gas costs.

- memory: Temporary storage during function execution (cheaper)

Only exists during function execution.

Cheaper than storage.

Used for function parameters, return values, and local variables.

- calldata: Read-only temporary storage for function parameters (most efficient)

Similar to memory but read-only.

Can't be modified.

Most gas-efficient.

Used primarily for external function parameters.

## Data box

- Be careful with loops in Solidity because each operation costs gas, and loops with too many iterations can exceed block gas limits. This is known as a denial of service (DoS).

- msg.value: The amount of ETH (in wei) sent with the function call. Only available if the function is marked as payable

- Events in Solidity are like announcements that your contract makes when something important happens. Events should be emitted when the contract state is updated

- The _ in the modifier represents where the function code will be executed. For example, if the _ is before the modifier logic, the function will be executed before the modifier logic.

- ABI : The ABI is like a smart contract's instruction manual that tells applications exactly how to talk to your contract on the blockchain.

It describes, using structured data, exactly what functions and data types are available for use in the contract and how to “call” or use them.
## Naming convention

- Contracts: PascalCase (like SimpleToken)

- Functions/variables: camelCase (like balanceOf)

- Private/internal state variables: prefix with _ (like _owner)