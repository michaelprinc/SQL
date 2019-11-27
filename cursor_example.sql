DECLARE
last_name  VARCHAR2(10);
cursor     c1 IS SELECT LAST_NAME
                 FROM EMPLOYEES_TABLE
                   WHERE DEPARTMENT_ID = 20;
BEGIN
    OPEN c1;
    LOOP
      FETCH c1 INTO last_name;
      EXIT WHEN c1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(last_name);
    END LOOP;
END;
 