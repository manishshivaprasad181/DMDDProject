-- PL/SQL script to insert 3 records into the 'TEST' table

-- Declare an exception for custom error handling
set serveroutput on;

DECLARE
  table_insert_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_insert_error, -1); -- ORA-00001: unique constraint (for primary key violation)
BEGIN
  -- Insert the first record
  execute immediate 'truncate table TEST333';
  INSERT INTO TEST333 (ID, NAME) VALUES (1, 'John Doe');

  -- Insert the second record
  INSERT INTO TEST333 (ID, NAME) VALUES (2, 'Jane Smith');

  -- Insert the third record
  INSERT INTO TEST333 (ID, NAME) VALUES (3, 'Bob Johnson');

  -- If the inserts are successful, display a message
  DBMS_OUTPUT.PUT_LINE('3 records inserted into TEST333 table successfully');
EXCEPTION
  WHEN table_insert_error THEN
    -- Handle the case when there's a primary key violation (record already exists)
    DBMS_OUTPUT.PUT_LINE('Error inserting records: Duplicate primary key');
  WHEN OTHERS THEN
    -- Handle other exceptions
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLCODE || ' - ' || SQLERRM);
END;
/


select * from TEST333;