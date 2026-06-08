# Data Structure

## ACCOUNTS.DAT

Indexed file. Organization: `INDEXED`. Access mode: `DYNAMIC`. Record key: `ACCOUNT-ID`.

### ACCOUNT-RECORD

| Field | PIC | Size | Description |
|-------|-----|------|-------------|
| `ACCOUNT-ID` | `9(10)` | 10 digits | Unique primary key, auto-incremented |
| `ACCOUNT-NAME` | `X(20)` | 20 chars | Account holder name |
| `ACCOUNT-BALANCE` | `S9(10)V99` | Signed, 10 int + 2 dec | Current balance (defaults to 0) |

**Total record size**: ~32 bytes (10 + 20 + 12 sign/decimal)

---

## ACCOUNTS-COUNTER.DAT

Sequential file. Stores single record tracking last assigned ID.

### ACCOUNT-COUNTER-RECORD

| Field | PIC | Size | Description |
|-------|-----|------|-------------|
| `LAST-ACCOUNT-ID` | `9(10)` | 10 digits | Last assigned account ID |

**Behavior**: read on startup, incremented by 1, rewritten after each account creation.

---

---

## TRANSACTIONS.DAT

Indexed file. Organization: `INDEXED`. Access mode: `DYNAMIC`. Record key: `TRANSACTION-ID`.

### TRANSACTION-RECORD

| Field | PIC | Size | Description |
|-------|-----|------|-------------|
| `TRANSACTION-ID` | `9(10)` | 10 digits | Sequential primary key, auto-incremented |
| `SOURCE-ID` | `9(10)` | 10 digits | Source account ID |
| `DESTINATION-ID` | `9(10)` | 10 digits | Destination account ID |
| `TRANSACTION-AMOUNT` | `S9(10)V99` | Signed, 10 int + 2 dec | Transferred amount |
| `TRANSACTION-TIMESTAMP` | `X(21)` | 21 chars | Date-time from `FUNCTION CURRENT-DATE` |

**Total record size**: ~53 bytes

---

## TRANSACTIONS-COUNTER.DAT

Sequential file. Stores single record tracking last assigned transaction ID.

### TRANSACTION-COUNTER-RECORD

| Field | PIC | Size | Description |
|-------|-----|------|-------------|
| `LAST-TRANSACTION-ID` | `9(10)` | 10 digits | Last assigned transaction ID |

**Behavior**: read on startup, incremented by 1, rewritten after each logged transaction.

---

## Working-Storage Variables

### account-creation.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-ACCOUNT-ID` | `X(10)` | Temp buffer for new ID |
| `WS-ACCOUNT-NAME` | `X(20)` | User input buffer for name |
| `WS-ACCOUNT-BALANCE` | `S9(10)V99` | Init to 0 |
| `WS-ACCOUNTS-STATUS` | `XX` | File status for ACCOUNTS.DAT |
| `WS-COUNTER-STATUS` | `XX` | File status for COUNTER.DAT |

### account-deletion.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-ACCOUNT-TO-DELETE-ID` | `9(10)` | User input: ID to delete |
| `WS-ACCOUNTS-STATUS` | `XX` | File status |

### account-list.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| WS-ACCOUNTS-STATUS | XX | File status |
| WS-END-OF-FILE-FLAG | 9 | EOF flag (88-level: 0=not EOF, 1=EOF) |

### transfer-money.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-SOURCE-ID` | `9(10)` | Source account ID |
| `WS-DESTINATION-ID` | `9(10)` | Destination account ID |
| `WS-AMOUNT` | `9(10)V99` | Amount to transfer |
| `WS-SOURCE-BALANCE` | `S9(10)V99` | Cached source balance |
| `WS-DESTINATION-BALANCE` | `S9(10)V99` | Cached destination balance |
| `WS-ACCOUNTS-STATUS` | `XX` | File status |
| `WS-TRANSACTIONS-STATUS` | `XX` | Transaction file status |
| `WS-TRANSACTIONS-COUNTER-STATUS` | `XX` | Transaction counter status |

### history-list.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-TRANSACTIONS-STATUS` | `XX` | File status |
| `WS-END-OF-FILE-FLAG` | `9` | EOF flag (88-level: 0=not EOF, 1=EOF) |

