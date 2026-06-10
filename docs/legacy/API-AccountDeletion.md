# account-deletion

## Overview
Deletes an existing account record by ID.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Read and delete account record |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record for ACCOUNTS.DAT |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Primary key |

### Workspace

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `WS-ACCOUNT-TO-DELETE-ID` | PIC 9(10) | 01 | User input for ID to delete |
| `WS-ACCOUNTS-STATUS` | PIC X(2) | 01 | File status codes |

## Flow

1. Open `ACCOUNTS.DAT` (I-O).
2. Prompt user for account ID to delete.
3. Move input to `ACCOUNT-ID`.
4. Read by key.
5. If found, delete record.
6. Display result message.
7. Close file.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| Account not found (INVALID KEY) | Display error "compte introuvable" |
| Delete failure | Display error message |

## Rules

- Account must exist to be deleted.

## Output

Success or failure messages.
