# Foundry Template [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gitpod]: https://gitpod.io/#https://github.com/bitbeckers/fux-workstream-6551
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/bitbeckers/fux-workstream-6551/actions
[gha-badge]: https://github.com/bitbeckers/fux-workstream-6551/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A Foundry-based template for developing Solidity smart contracts, with sensible defaults.

## Deployments:

### Sepolia

| Contract Name         | Address                                                                                                                       |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| FUX                   | [0xC4AE689DFF0D3aE05E1EDc192C8ddA5104D3fEc5](https://sepolia.etherscan.io/address/0xC4AE689DFF0D3aE05E1EDc192C8ddA5104D3fEc5) |
| StrategyRegistry      | [0xfbe4f1fbaA08d68B677e3928C05F50d0450A0B4a](https://sepolia.etherscan.io/address/0xfbe4f1fbaA08d68B677e3928C05F50d0450A0B4a) |
| WERKImplementation    | [0x15734d0EFD8E4a99c036009A0a03e195a092dC51](https://sepolia.etherscan.io/address/0x15734d0EFD8E4a99c036009A0a03e195a092dC51) |
| WERKFactory           | [0x19B7b76C8b7ec464b4Ff1D6DAac6e731C067073D](https://sepolia.etherscan.io/address/0x19B7b76C8b7ec464b4Ff1D6DAac6e731C067073D) |
| WERKNFT               | [0x4a08Ca3850C18868ab586fc3D9712Fac621593B3](https://sepolia.etherscan.io/address/0x4a08Ca3850C18868ab586fc3D9712Fac621593B3) |
| FUXStaking            | [0x9a50882F2Ceff6070638c0B6BBA7819AA3d5783a](https://sepolia.etherscan.io/address/0x9a50882F2Ceff6070638c0B6BBA7819AA3d5783a) |
| AllowListCoordination | [0xC1089127D4aF8f3ea4ba7E8be9FfC764a35198E8](https://sepolia.etherscan.io/address/0xC1089127D4aF8f3ea4ba7E8be9FfC764a35198E8) |
| SimplePeerEvaluation  | [0x5c8C0A4640acA702b5A73f76583622821c48432B](https://sepolia.etherscan.io/address/0x5c8C0A4640acA702b5A73f76583622821c48432B) |
| DirectDeposit         | [0x1C839f717d3eADC65a32eb299e20D5B174B63157](https://sepolia.etherscan.io/address/0x1C839f717d3eADC65a32eb299e20D5B174B63157) |
| SimpleDistribution    | [0x93a14a00b199c0C6A839f576437eeEd4C10d7c4C](https://sepolia.etherscan.io/address/0x93a14a00b199c0C6A839f576437eeEd4C10d7c4C) |

| Strategy               | StrategyID                                                         |
| ---------------------- | ------------------------------------------------------------------ |
| FUX Staking            | 0xc5d56f1663d45b9bd628d5cb9a8567537c74d0499888ae2f3ba92f5b1ab8a1da |
| AllowList Coordination | 0x605d89f8b72fbfa3b73dd22c93b53f840b5cb13a21e73440e6ea59da5692e79f |
| Simple Peer Evaluation | 0xac08e11cc866c49dc2b6452d20130ffeb230a76af653e43dd6c4498f836ae021 |
| Direct Deposit Funding | 0x8c596aae9b57e4d99eb73cbc35640a66fc74b08189da60188008fe44ce424d3b |
| Simple Distribution    | 0xc1bc24f60b5b9f84173b4fd86b03e32853c342133a4749eec79714cb413df34a |

## Installing Dependencies

Foundry typically uses git submodules to manage dependencies, but this template uses Node.js packages because
[submodules don't scale](https://twitter.com/PaulRBerg/status/1736695487057531328).

This is how to install dependencies:

1. Install the dependency using your preferred package manager, e.g. `bun install dependency-name`
   - Use this syntax to install from GitHub: `bun install github:username/repo-name`
2. Add a remapping for the dependency in [remappings.txt](./remappings.txt), e.g.
   `dependency-name=node_modules/dependency-name`

Note that OpenZeppelin Contracts is pre-installed, so you can follow that as an example.

## Usage

This is a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

Deploy to Anvil:

```sh
$ forge script script/Deploy.s.sol --broadcast --fork-url http://localhost:8545
```

For this script to work, you need to have a `MNEMONIC` environment variable set to a valid
[BIP39 mnemonic](https://iancoleman.io/bip39/).

For instructions on how to deploy to a testnet or mainnet, check out the
[Solidity Scripting](https://book.getfoundry.sh/tutorials/solidity-scripting.html) tutorial.

### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Lint

Lint the contracts:

```sh
$ bun run lint
```

### Test

Run the tests:

```sh
$ forge test
```

Generate test coverage and output result to the terminal:

```sh
$ bun run test:coverage
```

Generate test coverage with lcov report (you'll have to open the `./coverage/index.html` file in your browser, to do so
simply copy paste the path):

```sh
$ bun run test:coverage:report
```

## License

This project is licensed under MIT.
