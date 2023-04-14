# Proposal Simulation Framework

The Proposal Simulation Framework is a powerful tool for developers to test and validate governance proposals for their smart contracts. By simulating the various stages of a proposal, it becomes easier to identify issues and ensure the proposal works as intended.

## Overview

The framework is built around the `IProposal` interface and a set of contracts that implement this interface. These contracts include `TestProposals`, `MultisigProposal`, and `TimelockProposal`.

## IProposal Interface

The `IProposal` interface defines the required methods that each proposal should implement. These methods include:

- `name()`: Returns the name of the proposal, e.g., "VIP16".
- `setDebug(bool)`: Enables or disables debug logs.
- `deploy(Addresses)`: Deploys contracts and adds them to the list of addresses.
- `afterDeploy(Addresses, address)`: Initializes and links contracts together after deployment.
- `run(Addresses, address)`: Executes the proposal (e.g., queue actions in the Timelock, or perform a series of Multisig calls).
- `teardown(Addresses, address)`: Tears down the proposal (e.g., reverts changes made during the `afterDeploy()` step).
- `validate(Addresses, address)`: Performs validation checks after the proposal has been executed.

## TestProposals Contract

The `TestProposals` contract is used to test a series of proposals in a controlled environment. It provides methods to add proposals to be tested, set up the environment, and run the proposals through their various stages.

## MultisigProposal Contract

The `MultisigProposal` contract is an abstract contract that inherits from `Proposal`. It provides methods to add and simulate Multisig actions.

## TimelockProposal Contract

The `TimelockProposal` contract is an abstract contract that inherits from `Proposal`. It provides methods to add and simulate Timelock actions.

## Proposal Stages

Each proposal goes through the following stages:

1. **Deploy**: In this stage, contracts are deployed and added to the list of addresses.
2. **After-deploy**: Here, contracts are initialized and linked together after deployment.
3. **Run**: The proposal is executed, involving actions like queuing actions in the Timelock or performing a series of Multisig calls.
4. **Teardown**: In this stage, the proposal is torn down, and any changes made during the `afterDeploy()` step are reverted.
5. **Validate**: Finally, validation checks are performed after the proposal has been executed to ensure the proposal's success.

## Authors

This framework was created by Elliot Friedman and Erwan Beauvois. It is inspired by the Fei proposal simulation framework.
