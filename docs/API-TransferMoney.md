# transfer-money

## Overview
Transfers a specified amount from a source account to a destination account.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Read/Rewrite records by key |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record area for file operations |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Primary key |
| `ACCOUNT-NAME` | PIC X(20) | 05 | Account name |
| `ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Account balance |

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
9. Display new balances.
10. Close file.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| Source account not found | Display error, stop |
| Destination account not found | Display error, stop |
| Write/Rewrite failure | Display error message |

## Rules

- Both accounts must exist.
- Credit only performed if debit succeeds.

## Output

Confirmation message and updated balances.
