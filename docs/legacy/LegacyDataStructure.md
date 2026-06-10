# Legacy Banking — Data Structure

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
| `WS-ACCOUNTS-STATUS` | `XX` | File status |
| `WS-END-OF-FILE-FLAG` | `9` | EOF flag (88-level: 0=not EOF, 1=EOF) |

See [LegacyIndex.md](LegacyIndex.md) for the full legacy documentation index.
