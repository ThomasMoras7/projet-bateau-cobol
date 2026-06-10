# account-creation

## Overview
Creates new account record with auto-incremented ID.

## Data

### Files and structure

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Write new account record |
| `ACCOUNTS-COUNTER.DAT` | I-O | Read/increment/rewrite last ID |

#### ACCOUNTS

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-RECORD` | PIC X(35) | 01 | Record for ACCOUNTS.DAT |
| `ACCOUNT-ID` | PIC 9(5) | 05 | Auto-incremented account ID |
| `ACCOUNT-NAME` | PIC X(20) | 05 | Account name |
| `ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Account balance |

#### ACCOUNT-COUNTER

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `ACCOUNT-COUNTER-RECORD` | PIC X(10) | 01 | Record for ACCOUNTS-COUNTER.DAT |
| `LAST-ACCOUNT-ID` | PIC 9(10) | 05 | Last account ID used |

### Workspace

| Variable | Type | Structure | Usage |
|----------|------|-----------|-------|
| `WS-ACCOUNT-RECORD` | PIC X(30) | 01 | Work record for reading/writing |
| `WS-ACCOUNT-ID` | PIC X(10) | 05 | Work variable for account ID |
| `WS-ACCOUNT-NAME` | PIC X(20) | 05 | Work variable for account name |
| `WS-ACCOUNT-BALANCE` | PIC S9(10)V99 | 05 | Work variable for account balance |
| `WS-ACCOUNTS-STATUS` | PIC X(2) | 01 | File status codes |
| `WS-COUNTER-STATUS` | PIC X(2) | 01 | File status codes |

## Flow

1. Open `ACCOUNTS.DAT` (I-O).
2. Open `ACCOUNTS-COUNTER.DAT` (I-O).
3. Read counter.
4. Increment counter value by 1.
5. Rewrite counter.
6. Move new account ID to counter.
7. Prompt user for name. Loop until non-blank input.
8. Write new account record to `ACCOUNTS.DAT`.
9. Close files.

### Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create file, reopen |
| `ACCOUNTS-COUNTER.DAT` missing (status 35) | Auto-create with ID=0, reopen |
| Counter unreadable (status 10) | Reset to 0, continue |
| Write failure (RETURN-CODE ≠ 0) | Display error, close file |

## Rules

- Account name must not be blank.

## Output

Success or failure messages.
