USE [Draycir.SDC]
DECLARE @TableName varchar(255)
DECLARE TableCursor CURSOR FOR
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'base table'
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
    DBCC DBREINDEX(@TableName,' ',90)
    FETCH NEXT FROM TableCursor INTO @TableName
END
CLOSE TableCursor
DEALLOCATE TableCursor

-- Once complete, then run this script:

USE [Draycir.SDC]
GO
DECLARE @sql NVARCHAR(MAX);
SELECT @sql = (SELECT 'UPDATE STATISTICS ' +
quotename(s.name) + '.' + quotename(o.name) +
' WITH FULLSCAN; ' AS [text()]
    FROM sys.objects o
        JOIN sys.schemas s ON o.schema_id = s.schema_id
    WHERE o.type = 'U'
    FOR XML PATH(''), TYPE).value('.', 'nvarchar(MAX)');
EXEC (@sql)
