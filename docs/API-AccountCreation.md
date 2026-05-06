# account-creation

**Program-ID**: `ACCOUNT-CREATION`
**Author**: Thomas Moras
**Source**: `src/account-creation.cbl`

## Purpose
Creates new account record with auto-incremented ID.

## Files Used

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Write new account record |
| `ACCOUNTS-COUNTER.DAT` | I-O | Read/increment/rewrite last ID |

## Flow

1. Open `ACCOUNTS.DAT` (I-O). If missing (status `35`), create then reopen.
2. Open `ACCOUNTS-COUNTER.DAT` (I-O). If missing, create with initial ID `0`.
3. Read counter → increment by 1 → assign as new `ACCOUNT-ID` → rewrite counter.
4. Prompt user for name. Loop until non-blank input.
5. Write record (ID + name + balance=0) to `ACCOUNTS.DAT`.
6. Close both files.

## User Interaction

| Prompt | Input | Validation |
|--------|-------|------------|
| "Entrez votre nom (20 caracteres max) :" | Account name | Must not be blank (loops) |

## Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create file, reopen |
| `ACCOUNTS-COUNTER.DAT` missing (status 35) | Auto-create with ID=0, reopen |
| Counter unreadable (status 10) | Reset to 0, continue |
| Write failure (RETURN-CODE ≠ 0) | Display error, close file |
