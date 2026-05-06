# account-deletion

**Program-ID**: `ACCOUNT-DELETION`
**Author**: Thomas Moras
**Source**: `src/account-deletion.cbl`

## Purpose
Deletes existing account by ID lookup.

## Files Used

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Read + delete record by key |

## Flow

1. Open `ACCOUNTS.DAT` (I-O). If missing (status `35`), create then reopen.
2. Prompt user for account ID to delete.
3. Read by key. If found → delete. If not found → display error.
4. Close file.

## User Interaction

| Prompt | Input | Validation |
|--------|-------|------------|
| "Entrez l'ID du compte a supprimer :" | Account ID (numeric) | None (invalid key → error msg) |

## Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| Account not found (INVALID KEY) | Display "compte introuvable" |
| Delete failure (INVALID KEY on DELETE) | Display "impossible de supprimer" |
