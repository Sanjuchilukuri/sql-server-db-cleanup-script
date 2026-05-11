# Database Cleanup Script - README

## Overview
This SQL Server script removes all user-created database objects from the selected database.  
It is primarily intended for:

- Development environment resets
- Test database cleanup
- CI/CD pipeline database refresh
- Local database reinitialization

The script dynamically identifies and deletes user-created objects while excluding system objects.

---

# Objects Removed

The script removes the following objects in sequence:

1. Foreign Keys
2. Views
3. Stored Procedures
4. Functions
5. Tables

---

# Supported Database

- Microsoft SQL Server
- Azure SQL Database

---

# Important Warning

⚠️ This script permanently deletes database objects.

Before running:

- Ensure you are connected to the correct database
- Take a backup if required
- Do not execute in Production unless explicitly intended

---

# Script Execution Order

The script removes objects in dependency-safe order.

| Step | Object Type | Reason |
|---|---|---|
| 1 | Foreign Keys | Prevent table dependency conflicts |
| 2 | Views | Remove object dependencies |
| 3 | Stored Procedures | Cleanup executable objects |
| 4 | Functions | Remove reusable database functions |
| 5 | Tables | Final cleanup |

---

# System Object Protection

The script uses:

```sql
WHERE is_ms_shipped = 0
```

This ensures:

- System tables are not deleted
- SQL Server internal objects are protected
- Azure system views remain untouched

---

# Usage Instructions

## Step 1 — Open SQL Server Management Studio (SSMS)

Connect to the target SQL Server instance.

---

## Step 2 — Select the Database

Choose the database you want to clean.

Example:

```sql
USE YourDatabaseName;
GO
```

---

## Step 3 — Execute the Script

Run the cleanup script.

Execution time depends on:

- Number of tables
- Number of stored procedures
- Database size
- Existing dependencies

---

# Expected Result

After successful execution:

- All user tables are removed
- All stored procedures are removed
- All views are removed
- All functions are removed
- All foreign keys are removed

System objects remain intact.

---

# Common Issues

## 1. Permission Errors

### Example

```text
Cannot drop the view because it does not exist or you do not have permission
```

### Resolution

Ensure the executing user has:

- `db_owner` role
or
- `ALTER` / `DROP` permissions

---

## 2. Active Connections

Tables may fail to drop if:

- Another session is using the table
- Transactions are active

### Resolution

Close active connections before execution.

---

## 3. Schema-bound Objects

Some views or functions may be schema-bound.

### Resolution

Drop dependent objects manually if required.

---

# Recommended Usage Scenarios

| Scenario | Recommended |
|---|---|
| Local Development Reset | ✅ |
| QA/Test Environment Cleanup | ✅ |
| CI/CD Database Refresh | ✅ |
| Production Database | ⚠️ Use Carefully |

---

# Best Practice Recommendation

For complete environment resets, dropping and recreating the database is faster:

```sql
USE master;

ALTER DATABASE YourDatabaseName
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

DROP DATABASE YourDatabaseName;

CREATE DATABASE YourDatabaseName;
```

---

# Notes

- Indexes are automatically removed when tables are dropped
- Primary keys and constraints attached to tables are removed automatically
- Dynamic SQL is used for flexible object discovery

---

# Author Notes

This script is intended for administrative and development use cases where rapid database cleanup is required while preserving SQL Server system objects.
