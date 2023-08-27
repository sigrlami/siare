# Siare - Verified Randomness On-Chain

DApp to showcase VRF (Verfified Randomness Function) for smart-contracts.

- allows to setup verified feed of random numbers
- allows to setup data feed from Web2 services and place in on-chain with additional verification

## Rationale

Whilst it is true that computers can generate random numbers upon user request, in actuality, these numbers are not truly random. This is because the algorithm used to generate them is created from an initial value, and given enough computational power, anyone can break down the sequence of random numbers by knowing the algorithm and initial value. This effectively renders the generation of such numbers unreliable, hence why these generators are referred to as pseudorandom. There are potential ways to generate truly random numbers by using physical events that occur in a genuinely random way, such as nuclear oscillation noise or weather data.

Blockchains, however, are even more limited in their ability to generate random numbers due to being locked within a virtual machine (VM) execution environment. Knowing the internal workings of the VM can provide a means to break down the number generation process in the same way.

Random numbers play a vital role in various DeFi applications, including fair NFT launches, gambling, gaming, and assigning user roles in a DAO. Without an element of randomness, these applications can be easily exploited, and the outcome can be predicted.

Verifiable Random Function [VRFs](https://medium.com/algorand/algorand-releases-first-open-source-code-of-verifiable-random-function-93c2960abd61) help to solve randomness issue via cryptographics algorithm and rely on power of distribution. Most blockchain have both: cryptographic capabilities and set of parties that are distributed spatialy and provide individual computation.

## Structure

- `siare-core` - base data types and logic that can be used regardless of VM type
- `siare-accumulate` - additional data types and functions to work on Accumulate
- `siare-concordium` - additional data types and functions to work on Concordium
- `siare-near` - additional data types and functions to work on Near
- `siare-app` - minimalistic frontend

modules for other blockchains will be added in future.

## Tokenomics

<to be defined>
