# Rows Limiting In Oracle

This is used when we want to return only a subset of qualified data, it can be used after any WHERE or ORDER BY clause to limit the number or percentage of rows returned.

Instead of basing on business logic, the ROW LIMITING clauses are used to limit just the result subset, like only the first 10 rows or second dozen or last 5 rows

## `FETCH`

Limit on the rows returned by the SELECT statement are specified by the FETCH statement, consider eg

```sql
SELECT * FROM good_projs FETCH FIRST 10 ROWS ONLY;

SELECT * FROM good_projs FETCH FIRST 10 ROWS ONLY;
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH FIRST 10 ROWS ONLY;
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH FIRST 10 ROWS WITH TIES;

SELECT * FROM good_projs FETCH NEXT 10 ROWS ONLY;
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH NEXT 10 ROWS ONLY;
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH NEXT 10 ROWS WITH TIES;
-- ALSO CAN BE USED WITH PERCENTAGE
-- FIRST and NEXT are identical logically, are just gramatically available
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH FIRST 20 PERCENT ROWS WITH TIES;

-- WITHOUT NUMBER OF ROWS
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH NEXT ROW ONLY;
SELECT * FROM good_projs ORDER BY DAYS DESC NULLS LAST FETCH NEXT ROW WITH TIES;
```

Keywords and Options for the `FETCH` clause

- `FETCH` - (required)
- either `FIRST` or `NEXT` (one is required)
- a valid expression that evaluates to a number (optional, default to 1 row)
- keyword `PERCENT` (optional) - requires a number before it, and make it evaluate as a percentage rather than a numeric value
- Either `ROW` or `ROWS` (one is required) - no particular logical difference, just grammatically both present
- either `ONLY` or `WITH TIES` (one is required)
  - `ONLY` - returns only the number specified, no less
  - `WITH TIES` - returns the number specified with additional rows in case the ORDER BY is included and the ordering pairs had a tie

### WITH TIES

Is tied to the `ORDER BY` clause, and without it, it will only behave as `ONLY`

forexample 3 students have tied to the same score value, and you want to order the results SET based on score,

Including with ties after the ORDER BY clause as seen above, will return all three students.

When used without the ORDER BY clause, no error is returned, itjust act as ONLY

## OFFSET

By default row limiting will start with the first returned row, but you can only specify that the fetch starts elsewhere, like skip the first 2 data and starts at a specific number range

It can be used alone or used with FETCH

```SQL
select * from good_projs offset 5 rows;
select * from good_projs FETCH FIRST 5 ROWS ONLY;
select * from good_projs offset 5 rows FETCH FIRST 5 ROWS ONLY;
select * from good_projs offset 5 rows FETCH FIRST 10 ROWS ONLY;
```

Summary on OFFSET

| OFFSET Usage                      | Note                 | Impact to Ranges                                      |
| --------------------------------- | -------------------- | ----------------------------------------------------- |
| Ommitted, or negative number, 0   | DEFAULTS TO OFFSET 0 | returns starting from the first returned by the query |
| +ve number < total available rows |                      | Range begins with OFFSET row                          |
| +ve number > total available rows |                      | No rows returned                                      |

