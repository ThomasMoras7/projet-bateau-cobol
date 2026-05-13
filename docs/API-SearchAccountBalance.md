# search-account-balance

## Overview
Retrieves and displays the balance of a specific account by its ID.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Read record by key |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record for ACCOUNTS.DAT |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Primary key |
| `ACCOUNT-NAME` | PIC X(20) | 05 | Account name |
| `ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Account balance |

### Workspace

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `WS-SEARCH-ID` | PIC 9(10) | 01 | User input for ID to search |
| `WS-ACCOUNTS-STATUS` | PIC X(2) | 01 | File status codes |

## Flow

1. Open `ACCOUNTS.DAT` (I-O).
2. Prompt user for account ID to search.
3. Move input to `ACCOUNT-ID`.
4. Read record by key.
5. If found, display balance.
6. If not found, display error message.
7. Close file.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| Account not found (INVALID KEY) | Display "Account not found" |

## Rules

- Search is performed by exact ID match.

## Output

Account balance or error message.
