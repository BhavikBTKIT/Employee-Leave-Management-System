# Employee Leave Management System

A MySQL database project that manages employees, departments, attendance, leave types, and leave requests.

## Included

- Five normalized relational tables with primary keys, foreign keys, `UNIQUE`, `CHECK`, and `DEFAULT` constraints.
- CRUD examples, multi-table joins, aggregate reports, `GROUP BY`, and a subquery.
- Indexes for department, attendance, leave-status, and date-range lookups.
- A view, two stored procedures, and two triggers.

## Run in MySQL Workbench

1. Open MySQL Workbench and connect to local MySQL server.
2. Open and run these files in order: `01_schema.sql`, `02_sample_data.sql`, `03_automation.sql`.
3. Open `04_crud_and_reports.sql` and run individual sections to test the project.

Or run from a terminal in this folder:

```powershell
mysql -u root -p < 01_schema.sql
mysql -u root -p < 02_sample_data.sql
mysql -u root -p < 03_automation.sql
```

## Database Design

- `departments` → has many `employees`
- `employees` → has many `attendance` records and `leave_requests`; may reference another employee as manager
- `leave_types` → categorizes leave requests and sets an annual limit
- `leave_requests` → stores the approval workflow
- `attendance` → one record per employee per date

The approval trigger creates/updates `ON_LEAVE` attendance entries when a leave request becomes approved.
