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
| FUX                   | [0xDBB776B586C2254f5228dfa368F9adc8D4Dcd8f1](https://sepolia.etherscan.io/address/0xDBB776B586C2254f5228dfa368F9adc8D4Dcd8f1) |
| StrategyRegistry      | [0x99591f8DC4a0ec3956689545b39CC0521F2f9960](https://sepolia.etherscan.io/address/0x99591f8DC4a0ec3956689545b39CC0521F2f9960) |
| WERKImplementation    | [0x15734d0EFD8E4a99c036009A0a03e195a092dC51](https://sepolia.etherscan.io/address/0x15734d0EFD8E4a99c036009A0a03e195a092dC51) |
| WERKFactory           | [0x19B7b76C8b7ec464b4Ff1D6DAac6e731C067073D](https://sepolia.etherscan.io/address/0x19B7b76C8b7ec464b4Ff1D6DAac6e731C067073D) |
| WERKNFT               | [0x4a08Ca3850C18868ab586fc3D9712Fac621593B3](https://sepolia.etherscan.io/address/0x4a08Ca3850C18868ab586fc3D9712Fac621593B3) |
| FUXStaking            | [0x9a50882F2Ceff6070638c0B6BBA7819AA3d5783a](https://sepolia.etherscan.io/address/0x9a50882F2Ceff6070638c0B6BBA7819AA3d5783a) |
| AllowListCoordination | [0x92285ac6f06e208D86E06D515F1686f188865518](https://sepolia.etherscan.io/address/0x92285ac6f06e208D86E06D515F1686f188865518) |
| SimplePeerEvaluation  | [0x06342A17A45F5A8C33ae5D6937612d350Ad19B39](https://sepolia.etherscan.io/address/0x06342A17A45F5A8C33ae5D6937612d350Ad19B39) |
| DirectDeposit         | [0xDc989980807f59155de9d6776025228856742E23](https://sepolia.etherscan.io/address/0xDc989980807f59155de9d6776025228856742E23) |
| SimpleDistribution    | [0x9D1501F75f733D4763ce2886Dbc96883F4EB867e](https://sepolia.etherscan.io/address/0x9D1501F75f733D4763ce2886Dbc96883F4EB867e) |

IDs in registry:

bytes32 fuxStakingId = 0x6b8751b8367be0bc1384cce56ff51454f781964e1c715825901b363d506b3bcd; bytes32 allowListId =
0xe6bd3e801e71e9e619dfe1e2e91c4d171fc8a6eaa81555c12619e8683b0d33b1; bytes32 peerEvaluationId =
0xf78fdd634cce0d68228ce09dc7681e20a9d39df11b51c5265fca401ed315c83c; bytes32 directDepositId =
0x7b26ece6b81f2b8ab0f5b0f95284bbfe16c9d28709264d97553d58c85cf32a30; bytes32 simpleDistributionId =
0xd8afd210eaa5981adc1e9a7771be634fa551d224849313cc5572351b1a273069;

## What's Inside

- [Forge](https://github.com/foundry-rs/foundry/blob/master/forge): compile, test, fuzz, format, and deploy smart
  contracts
- [Forge Std](https://github.com/foundry-rs/forge-std): collection of helpful contracts and cheatcodes for testing
- [PRBTest](https://github.com/PaulRBerg/prb-test): modern collection of testing assertions and logging utilities
- [Prettier](https://github.com/prettier/prettier): code formatter for non-Solidity files
- [Solhint](https://github.com/protofire/solhint): linter for Solidity code

## Getting Started

Click the [`Use this template`](https://github.com/PaulRBerg/foundry-template/generate) button at the top of the page to
create a new repository with this repo as the initial state.

Or, if you prefer to install the template manually:

```sh
$ mkdir my-project
$ cd my-project
$ forge init --template PaulRBerg/foundry-template
$ bun install # install Solhint, Prettier, and other Node.js deps
```

If this is your first time with Foundry, check out the
[installation](https://github.com/foundry-rs/foundry#installation) instructions.

## Features

This template builds upon the frameworks and libraries mentioned above, so please consult their respective documentation
for details about their specific features.

For example, if you're interested in exploring Foundry in more detail, you should look at the
[Foundry Book](https://book.getfoundry.sh/). In particular, you may be interested in reading the
[Writing Tests](https://book.getfoundry.sh/forge/writing-tests.html) tutorial.

### Sensible Defaults

This template comes with a set of sensible default configurations for you to use. These defaults can be found in the
following files:

```text
├── .editorconfig
├── .gitignore
├── .prettierignore
├── .prettierrc.yml
├── .solhint.json
├── foundry.toml
└── remappings.txt
```

### VSCode Integration

This template is IDE agnostic, but for the best user experience, you may want to use it in VSCode alongside Nomic
Foundation's [Solidity extension](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity).

For guidance on how to integrate a Foundry project in VSCode, please refer to this
[guide](https://book.getfoundry.sh/config/vscode).

### GitHub Actions

This template comes with GitHub Actions pre-configured. Your contracts will be linted and tested on every push and pull
request made to the `main` branch.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

## Installing Dependencies

Foundry typically uses git submodules to manage dependencies, but this template uses Node.js packages because
[submodules don't scale](https://twitter.com/PaulRBerg/status/1736695487057531328).

This is how to install dependencies:

1. Install the dependency using your preferred package manager, e.g. `bun install dependency-name`
   - Use this syntax to install from GitHub: `bun install github:username/repo-name`
2. Add a remapping for the dependency in [remappings.txt](./remappings.txt), e.g.
   `dependency-name=node_modules/dependency-name`

Note that OpenZeppelin Contracts is pre-installed, so you can follow that as an example.

## Writing Tests

To write a new test contract, you start by importing [PRBTest](https://github.com/PaulRBerg/prb-test) and inherit from
it in your test contract. PRBTest comes with a pre-instantiated [cheatcodes](https://book.getfoundry.sh/cheatcodes/)
environment accessible via the `vm` property. If you would like to view the logs in the terminal output you can add the
`-vvv` flag and use [console.log](https://book.getfoundry.sh/faq?highlight=console.log#how-do-i-use-consolelog).

This template comes with an example test contract [Foo.t.sol](./test/Foo.t.sol)

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

## Related Efforts

- [abigger87/femplate](https://github.com/abigger87/femplate)
- [cleanunicorn/ethereum-smartcontract-template](https://github.com/cleanunicorn/ethereum-smartcontract-template)
- [foundry-rs/forge-template](https://github.com/foundry-rs/forge-template)
- [FrankieIsLost/forge-template](https://github.com/FrankieIsLost/forge-template)

## License

This project is licensed under MIT.
