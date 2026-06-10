# history-list

## Overview
Reads and displays all transaction journal entries sequentially.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `TRANSACTIONS.DAT` | I-O | Sequential read of all records |

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
| `WS-TRANSACTIONS-STATUS` | PIC X(2) | 01 | File status codes |
| `WS-END-OF-FILE-FLAG` | PIC 9 | 01 | EOF tracker (0=No, 1=Yes) |

## Flow

1. Open `TRANSACTIONS.DAT` (I-O).
2. Initialize EOF flag to 0.
3. Perform loop until EOF flag is 1.
4. Read next record.
5. At end, set EOF flag to 1.
6. If not end, display transaction details (ID, source, destination, amount, timestamp).
7. Close file.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `TRANSACTIONS.DAT` missing (status 35) | Auto-create, reopen |

## Rules

- Displays all records sequentially. No filtering or search.

## Output

List of transactions or empty journal message.
