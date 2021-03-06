# M-tools

A collection a useful tools for building queries in the Power Query Formula Language ("*M*") used by [Microsoft Power BI](https://powerbi.microsoft.com/).


## Usage

>Power BI does not (appear) to currently support external dependencies so setup is a little rudimentary.

1. Create a new blank query.
2. Copy the content of [m-tools.pq](m-tools.pq) to this query using the advanced editor.
3. Name the query `M`.

Functions may then be access from other queries as records on `M`. For example, `Pipe` may be invoked as:

    M[Pipe]({functionA, functionB, ...})

### Table Generators

If working with time based data, functions for generating tables which split it in interesting ways are also provides in [date-table.pq](date-table.pq) and [time-table.pq](time-table.pq). Once imported as queries, invoke these to generate table then define relationships with any time based data sets.

---


[M Language specification](https://msdn.microsoft.com/en-us/library/mt807488.aspx)

[Type system](https://msdn.microsoft.com/en-us/library/mt809131.aspx)

[Internal function references](https://msdn.microsoft.com/en-us/library/mt779182.aspx)
