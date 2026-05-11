DECLARE @sql NVARCHAR(MAX) = '';

/* ==============================
   DROP FOREIGN KEYS
================================ */
SELECT @sql += 
'ALTER TABLE [' + SCHEMA_NAME(schema_id) + '].[' + OBJECT_NAME(parent_object_id) + '] DROP CONSTRAINT [' + name + '];' + CHAR(10)
FROM sys.foreign_keys
WHERE is_ms_shipped = 0;

EXEC sp_executesql @sql;


/* ==============================
   DROP VIEWS
================================ */
SET @sql = '';

SELECT @sql += 
'DROP VIEW [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(10)
FROM sys.views
WHERE is_ms_shipped = 0;

EXEC sp_executesql @sql;


/* ==============================
   DROP STORED PROCEDURES
================================ */
SET @sql = '';

SELECT @sql += 
'DROP PROCEDURE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(10)
FROM sys.procedures
WHERE is_ms_shipped = 0;

EXEC sp_executesql @sql;


/* ==============================
   DROP FUNCTIONS
================================ */
SET @sql = '';

SELECT @sql += 
'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(10)
FROM sys.objects
WHERE type IN ('FN','TF','IF')
AND is_ms_shipped = 0;

EXEC sp_executesql @sql;


/* ==============================
   DROP TABLES
================================ */
SET @sql = '';

SELECT @sql += 
'DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(10)
FROM sys.tables
WHERE is_ms_shipped = 0;

EXEC sp_executesql @sql;
