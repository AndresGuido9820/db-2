DECLARE

a NUMBER(2) := 10;

pi CONSTANT NUMBER(5, 4) := 3.1416;

BEGIN

DBMS_OUTPUT.PUT_LINE('a = ' || a || ' Pi = ' || pi);

a := -99;

DBMS_OUTPUT.PUT_LINE('a = ' || a);

-- pi := 3.1111;

DBMS_OUTPUT.PUT_LINE('pi = ' || pi);

END;

/
