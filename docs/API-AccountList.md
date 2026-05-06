# account-list

**Program-ID**: `ACCOUNT-LIST`
**Author**: Thomas Moras
**Source**: `src/account-list.cbl`

## Purpose
Lists all accounts stored in data file.

## Files Used

| File | Mode | Role |
|------|------|------|
| `ACCOUNTS.DAT` | I-O | Sequential read of all records |

## Flow

1. Open `ACCOUNTS.DAT` (I-O). If missing (status `35`), create then reopen.
2. Loop: read next record until EOF.
3. For each record, display ID, name, balance, separator line.
4. Close file.

## User Interaction
None — output only.

## Output Format
```
0000000001
John Doe
+0000000000.00
-------------------
0000000002
Jane Smith
+0000000000.00
-------------------
```

## Error Handling

| Condition | Behavior |
|-----------|----------|
| `ACCOUNTS.DAT` missing (status 35) | Auto-create, reopen |
| EOF reached (AT END) | Set flag, exit loop |
