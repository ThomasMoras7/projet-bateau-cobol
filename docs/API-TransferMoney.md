# transfer-money

## Overview
Transfers a specified amount from a source account to a destination account.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Read/Rewrite records by key |
| `TRANSACTIONS.DAT` | I-O | Write journal entry |
| `TRANSACTIONS-COUNTER.DAT` | I-O | Read/Write counter |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record area for file operations |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Primary key |
| `ACCOUNT-NAME` | PIC X(20) | 05 | Account name |
| `ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Account balance |

#### TRANSACTIONS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `TRANSACTION-RECORD` | PIC X(53) | 01 | Record area for file operations |
| `TRANSACTION-ID` | PIC 9(10) | 05 | Primary key |
| `SOURCE-ID` | PIC 9(10) | 05 | Source account ID |
| `DESTINATION-ID` | PIC 9(10) | 05 | Destination account ID |
| `TRANSACTION-AMOUNT` | PIC S9(10)V99 | 05 | Transferred amount |
| `TRANSACTION-TIMESTAMP` | PIC X(21) | 05 | Date-time from FUNCTION CURRENT-DATE |

### Workspace

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `WS-SOURCE-ID` | PIC 9(10) | 01 | Source Account ID input |
| `WS-DESTINATION-ID` | PIC 9(10) | 01 | Destination Account ID input |
| `WS-AMOUNT` | PIC 9(10)V99 | 01 | Amount to transfer |
| `WS-DEBIT-STATUS` | PIC X | 01 | Success flag (Y/N) |
| `WS-SOURCE-ACCOUNT-DATA` | PIC X(35) | 01 | Buffer for source account |
| `WS-DESTINATION-ACCOUNT-DATA` | PIC X(35) | 01 | Buffer for destination account |
| `WS-ACCOUNTS-STATUS` | PIC X(2) | 01 | File status codes |
| `WS-TRANSACTIONS-STATUS` | PIC X(2) | 01 | File status codes |
| `WS-TRANSACTIONS-COUNTER-STATUS` | PIC X(2) | 01 | Counter file status codes |

## Flow

1. Open `ACCOUNTS.DAT` (I-O).
2. Prompt for source account ID. Read and move to buffer.
3. Prompt for destination account ID. Read and move to buffer.
4. Prompt for transfer amount.
5. Check if source balance >= amount.
6. Subtract amount from source balance in buffer.
7. Move buffer to record area and `REWRITE` source record.
8. If debit successful (NOT INVALID KEY):
   a. Add amount to destination balance in buffer.
   b. Move buffer to record area and `REWRITE` destination record.
   c. Open `TRANSACTIONS.DAT` and `TRANSACTIONS-COUNTER.DAT` (auto-create if missing).
   d. Read counter, increment, write journal entry with source ID, destination ID, amount, and `FUNCTION CURRENT-DATE`.
9. Display new balances.
10. Close all files.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| `TRANSACTIONS.DAT` missing (status 35) | Auto-create, reopen |
| `TRANSACTIONS-COUNTER.DAT` missing (status 35) | Auto-create with `LAST-TRANSACTION-ID` = 0, reopen |
| Source account not found | Display error, stop |
| Destination account not found | Display error, stop |
| Write/Rewrite failure | Display error message |

## Rules

- Both accounts must exist.
- Credit only performed if debit succeeds.

## Output

Confirmation message and updated balances.
