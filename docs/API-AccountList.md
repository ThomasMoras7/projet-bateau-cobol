# account-list

## Overview
Lists all account records stored in the data file.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Sequential read of all records |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record for ACCOUNTS.DAT |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Account ID |
| `ACCOUNT-NAME` | PIC X(20) | 05 | Account name |
| `ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Account balance |

### Workspace

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `WS-ACCOUNTS-STATUS` | PIC X(2) | 01 | File status codes |
| `WS-END-OF-FILE-FLAG` | PIC 9 | 01 | EOF tracker (0=No, 1=Yes) |

## Flow

1. Open `ACCOUNTS.DAT` (I-O).
2. Initialize EOF flag to 0.
3. Perform loop until EOF flag is 1.
4. Read next record.
5. At end, set EOF flag to 1.
6. If not end, display account details (ID, Name, Balance).
7. Close file.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |

## Rules

- Displays all records sequentially.

## Output

List of accounts or empty message.
