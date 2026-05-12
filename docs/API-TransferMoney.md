# Transfer Money API

## Overview
Transfers a specified amount from one account to another.

## Description
This program updates two account records in a single execution.

## Input
- `WS-SOURCE-ID`: Source Account ID.
- `WS-DESTINATION-ID`: Destination Account ID.
- `WS-AMOUNT`: Amount to transfer.

## Rules
- Both accounts must exist in `ACCOUNTS.DAT`.
- If there is an error with the debit, the credit won't be performed.

## Output
- Success: "Transfer successful" + new balances.
- Failure: Error message specifying the cause (missing account, insufficient funds, etc.).

## Execution
Compile and run `transfer-money.cbl`.
