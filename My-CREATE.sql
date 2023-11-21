-- PL/SQL script to create a table called 'TEST' with exception handling
-- If the table already exists, drop the table and create it again

-- Declare an exception for custom error handling
set serveroutput on;
DECLARE
  table_creation_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_creation_error, -955); -- ORA-00955: name is already used by an existing object

  -- Procedure to create or recreate the 'TEST' table
  PROCEDURE create_or_recreate_test_table IS
  BEGIN
    -- Attempt to create the 'TEST' table
    EXECUTE IMMEDIATE 'CREATE TABLE TEST333 (
                         ID NUMBER PRIMARY KEY,
                         NAME VARCHAR2(50)
                       )';

    -- If the table creation is successful, display a message
    DBMS_OUTPUT.PUT_LINE('Table TEST created successfully');
  EXCEPTION
    WHEN table_creation_error THEN
      -- Handle the case when the table already exists
      DBMS_OUTPUT.PUT_LINE('Table TEST already exists. Dropping and recreating...');

      -- Drop the existing 'TEST' table
      EXECUTE IMMEDIATE 'DROP TABLE TEST333';

      -- Recreate the 'TEST333' table
      create_or_recreate_test_table;

      -- Display a message after recreating the table
      DBMS_OUTPUT.PUT_LINE('Table TEST333 dropped and recreated successfully');
    WHEN OTHERS THEN
      -- Handle other exceptions
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END create_or_recreate_test_table;

BEGIN
  -- Call the procedure to create or recreate the 'TEST333' table
  create_or_recreate_test_table;
END;
/

select * from TEST333;
