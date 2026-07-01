# Legacy Banking — Features

## Account Management

### Creation
- Prompts user for a name (20 chars max, cannot be blank)
- Auto-generates unique incremental ID via counter file
- Initializes balance to 0
- Persists account to indexed data file

### Deletion
- Prompts user for account ID
- Looks up account by primary key
- Deletes matching record or displays error if not found

### Listing
- Reads all accounts sequentially from data file
- Displays ID, name, and balance for each record

### History
- Lists all recorded transactions for an account

### Search
- Queries account balance by ID

### Transfer
- Transfers funds between two accounts

## Data Persistence
- All data stored in local binary files (`ACCOUNTS.DAT`, `ACCOUNTS-COUNTER.DAT`)
- Auto-creation of data files on first run if missing
- Indexed file organization for keyed access

## Portable Environment
- Self-contained GnuCOBOL 3.2.0 distribution
- Single PowerShell script sets up PATH and compiler variables
- No system-wide installation required

See [LegacyIndex.md](LegacyIndex.md) for the full legacy documentation index.
