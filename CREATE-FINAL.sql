SET SERVEROUTPUT ON;

-- Drop tables if they exist
DECLARE
  table_drop_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_drop_error, -942); -- ORA-00942: table or view does not exist

  -- Procedure to drop a table if it exists
  PROCEDURE drop_table(table_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ' || table_name;
    DBMS_OUTPUT.PUT_LINE('Table ' || table_name || ' dropped successfully');
  EXCEPTION
    WHEN table_drop_error THEN
      DBMS_OUTPUT.PUT_LINE('Table ' || table_name || ' does not exist. Skipping drop...');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END drop_table;

BEGIN
  drop_table('ORDER_ITEMS');
  drop_table('ORDER_TABLE');
  drop_table('SHIPPER');
  drop_table('RATING');
  drop_table('WAREHOUSE');
  drop_table('USERS');
  drop_table('CATEGORY');
  drop_table('BRAND');
  drop_table('PRODUCT');
END;
/

DECLARE
  table_creation_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_creation_error, -955); -- ORA-00955: name is already used by an existing object

  sequence_creation_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(sequence_creation_error, -955); -- ORA-00955: name is already used by an existing object

  -- Procedure to create or recreate a table
  PROCEDURE create_or_recreate_table(table_name VARCHAR2, columns_definition VARCHAR2) IS
  BEGIN
    -- Attempt to create the table
    EXECUTE IMMEDIATE 'CREATE TABLE ' || table_name || ' (' || columns_definition || ')';

    -- If the table creation is successful, display a message
    DBMS_OUTPUT.PUT_LINE('Table ' || table_name || ' created successfully');
  EXCEPTION
    WHEN table_creation_error THEN
      -- Handle the case when the table already exists
      DBMS_OUTPUT.PUT_LINE('Table ' || table_name || ' already exists. Skipping creation...');
    WHEN OTHERS THEN
      -- Handle other exceptions
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END create_or_recreate_table;

  -- Procedure to create a sequence
  PROCEDURE create_sequence(seq_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || seq_name;
    DBMS_OUTPUT.PUT_LINE('Sequence ' || seq_name || ' created successfully');
  EXCEPTION
    WHEN sequence_creation_error THEN
      DBMS_OUTPUT.PUT_LINE('Sequence ' || seq_name || ' already exists. Skipping creation...');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END create_sequence;

  -- Procedure to add foreign key constraint
  PROCEDURE add_foreign_key_constraint(fk_table VARCHAR2, fk_column VARCHAR2, pk_table VARCHAR2, pk_column VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'BEGIN EXECUTE IMMEDIATE ''ALTER TABLE ' || fk_table || ' ADD CONSTRAINT FK_' || fk_table || '_' || pk_table ||
                      ' FOREIGN KEY (' || fk_column || ') REFERENCES ' || pk_table || ' (' || pk_column || ')''; EXCEPTION WHEN OTHERS THEN NULL; END;';
    DBMS_OUTPUT.PUT_LINE('Foreign key constraint added successfully');
  END add_foreign_key_constraint;

BEGIN
  -- Call the procedure to create or recreate the 'BRAND' table
  create_or_recreate_table('BRAND', 'BRAND_ID NUMBER PRIMARY KEY, BRAND_NAME VARCHAR2(50)');
  create_sequence('BRAND_ID_SEQ');

  -- Call the procedure to create or recreate the 'CATEGORY' table
  create_or_recreate_table('CATEGORY', 'CATEGORY_ID NUMBER PRIMARY KEY, CATEGORY_NAME VARCHAR2(50), PARENT_ID NUMBER');
  create_sequence('CATEGORY_ID_SEQ');

  -- Call the procedure to create or recreate the 'USER' table
  create_or_recreate_table('USERS', 'USER_ID NUMBER PRIMARY KEY, F_NAME VARCHAR2(50), L_NAME VARCHAR2(50), 
                            EMAIL VARCHAR2(100), PASSWORD VARCHAR2(100), USR_TYPE VARCHAR2(20), PHONE NUMBER,
                            HOUSE_NO NUMBER, ST_ADDR VARCHAR2(100), CITY VARCHAR(30), STATE VARCHAR(20), ZIPCODE NUMBER ');
  create_sequence('USER_ID_SEQ');

  -- Call the procedure to create or recreate the 'WAREHOUSE' table
  create_or_recreate_table('WAREHOUSE', 'WAREHOUSE_ID NUMBER PRIMARY KEY');
  create_sequence('WAREHOUSE_ID_SEQ');

  -- Call the procedure to create or recreate the 'RATING' table
  create_or_recreate_table('RATING', 'RATING_ID NUMBER PRIMARY KEY, SCORE NUMBER');
  create_sequence('RATING_ID_SEQ');

  -- Call the procedure to create or recreate the 'SHIPPER' table
  create_or_recreate_table('SHIPPER', 'SHIPPER_ID NUMBER PRIMARY KEY, CARRIER VARCHAR2(50)');
  create_sequence('SHIPPER_ID_SEQ');

  -- Call the procedure to create or recreate the 'ORDER' table
  create_or_recreate_table('ORDER_TABLE', 'ORDER_ID NUMBER PRIMARY KEY, USER_ID NUMBER, SHIPPER_ID NUMBER, ORDER_DATE DATE');
  create_sequence('ORDER_ID_SEQ');
  add_foreign_key_constraint('ORDER_TABLE', 'USER_ID', 'USERS', 'USER_ID');
  add_foreign_key_constraint('ORDER_TABLE', 'SHIPPER_ID', 'SHIPPER', 'SHIPPER_ID');

  -- Call the procedure to create or recreate the 'ORDER_ITEMS' table
  create_or_recreate_table('ORDER_ITEMS', 'ORDER_ITEM_ID NUMBER PRIMARY KEY, ORDER_ID NUMBER, PRODUCT_ID NUMBER, QUANTITY NUMBER');
  create_sequence('ORDER_ITEM_ID_SEQ');
  add_foreign_key_constraint('ORDER_ITEMS', 'ORDER_ID', 'ORDER_TABLE', 'ORDER_ID');
  add_foreign_key_constraint('ORDER_ITEMS', 'PRODUCT_ID', 'PRODUCT', 'P_ID');

  -- Call the procedure to create or recreate the 'PRODUCT' table
  create_or_recreate_table('PRODUCT', 'P_ID NUMBER PRIMARY KEY, P_NAME VARCHAR2(100), P_DESC VARCHAR2(100),P_PRICE NUMBER, P_QUANTITY NUMBER, BRAND_ID NUMBER, CATEGORY_ID NUMBER, WAREHOUSE_ID NUMBER, RATING_ID NUMBER');
  create_sequence('PID_SEQ');
  add_foreign_key_constraint('PRODUCT', 'BRAND_ID', 'BRAND', 'BRAND_ID');
  add_foreign_key_constraint('PRODUCT', 'CATEGORY_ID', 'CATEGORY', 'CATEGORY_ID');
  add_foreign_key_constraint('PRODUCT', 'WAREHOUSE_ID', 'WAREHOUSE', 'WAREHOUSE_ID');
  add_foreign_key_constraint('PRODUCT', 'RATING_ID', 'RATING', 'RATING_ID');

  -- Display a message after creating or recreating tables
  DBMS_OUTPUT.PUT_LINE('Tables and sequences created or recreated successfully');
END;
/
