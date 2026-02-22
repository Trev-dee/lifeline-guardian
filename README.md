# Lifeline Guardian

A decentralized dead-man switch smart contract that activates asset recovery when an owner becomes inactive.

## Overview

Lifeline Guardian is an on-chain solution for estate planning and contingency management. If the contract owner fails to "check in" within a specified timeout period, a designated beneficiary can trigger recovery of protected assets.

## Features

- **Inactivity Detection**: Tracks owner check-ins using block height
- **Configurable Timeout**: Set custom inactivity periods during initialization
- **Beneficiary Recovery**: Designate a recovery address
- **State Inspection**: Query contract status and expiration state
- **Fail-Safe Activation**: Trigger only after timeout threshold is exceeded

## Smart Contract Functions

### `initialize(checkin-timeout, recovery)`
Sets up the dead-man switch with timeout period and beneficiary address.

### `check-in()`
Owner resets the inactivity counter. Call periodically to prevent activation.

### `trigger()`
Activates the switch once timeout is exceeded. Returns the beneficiary principal.

### `status()`
Read-only view of contract state (active, last-checkin, timeout, beneficiary).

### `expired?()`
Read-only boolean indicating if the switch can be triggered.

## Usage

1. Deploy contract
2. Call `initialize()` with timeout (in blocks) and beneficiary address
3. Owner calls `check-in()` regularly to maintain active status
4. Once inactive beyond timeout, beneficiary calls `trigger()` to activate recovery


[Add your license here]
