SET SERVEROUTPUT ON;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE trains CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE stations CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE route CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE dispatchers CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE disp_info CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE disp_salary CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE delays CASCADE CONSTRAINTS';
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE trains(
        train_id varchar2(10) CONSTRAINT pk_tid PRIMARY KEY,
        train_capacity number(2) CONSTRAINT nn_tc NOT NULL,
        train_type varchar2(20)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE stations(
        station_id varchar2(10) CONSTRAINT pk_sid PRIMARY KEY,
        station_name varchar2(50) CONSTRAINT nn_name NOT NULL
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE route(
        route_id number(5) CONSTRAINT pk_rid PRIMARY KEY,
        station_id varchar2(10) REFERENCES stations(station_id),
        train_id varchar2(10) REFERENCES trains(train_id),
        route_day DATE DEFAULT SYSDATE,
        route_hour TIMESTAMP DEFAULT SYSTIMESTAMP 
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE dispatchers(
        admin_id number(5) CONSTRAINT pk_aid PRIMARY KEY,
        first_name varchar2(20) CONSTRAINT nn_fn NOT NULL,
        last_name varchar2(20) CONSTRAINT nn_ln NOT NULL,
        email varchar2(50) CONSTRAINT ck_email CHECK(email LIKE ''%@%''),
        phone varchar2(10),
        address varchar2(60) 
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE disp_info(
        disp_id number(5) REFERENCES dispatchers(admin_id),
        ranks varchar2(20),
        disp_info_id number(5) REFERENCES disp_info(disp_id),
        CONSTRAINT uk_did UNIQUE(disp_id)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE disp_salary(
        salary number(5),
        commission_pct number(2,2),
        disp_id number(5) REFERENCES disp_info(disp_id),
        CONSTRAINT uk_diid UNIQUE(disp_id)
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE delays(
        delay_id number(5) CONSTRAINT pk_did PRIMARY KEY,
        route_id number(4) REFERENCES route(route_id),
        expected_arrival TIMESTAMP CONSTRAINT nn_exarr NOT NULL,
        actual_arrival TIMESTAMP DEFAULT NULL,
        expected_departure TIMESTAMP CONSTRAINT nn_exdep NOT NULL,
        actual_departure TIMESTAMP DEFAULT NULL,
        delay_explanation varchar2(100),
        delay_code number(4) DEFAULT 1000,
        admin_id number(5) REFERENCES dispatchers(admin_id)
    )';
END;
/

--inserting values(some of the train id's are taken from www.cfrcalatori.ro 
--with some modified data)
BEGIN

EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R-E9213'', 3, ''Regio Express'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R-E9208'',2,''Regio Express'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R-E9214'',1,''Regio Express'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IR1581'', 4,''InterRegio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IR1587'', 2,''InterRegio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IR1583'', 4, ''InterRegio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IR1826'',3,''InterRegio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IR1824'', 4, ''InterRegio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IC531'', 6, ''InterCity'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''IC533'',1,''InterCity'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R9531'', 1, ''Regio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R9533'', 1,''Regio'')';
EXECUTE IMMEDIATE 'INSERT INTO trains VALUES(''R9535'', 2,''Regio'')';

--populating the stations table with the following "routes":
--pitesti - bucuresti (92--)
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''PITE'',''Pitesti'')';
--bucuresti - constanta (15--)
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''BUCU-N'',''Bucuresti Nord'')';
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''CONS'',''Constanta'')';
--ploiesti vest - brasov(5--)
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''PLOI-V'',''Ploiesti Vest'')';
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''BRAS'',''Brasov'')';
--craiova - videle (18--)
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''CRAI'',''Craiova'')';
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''VIDE'',''Videle'')';
--bascov - curtea de arges (95--)
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''BASC'',''Bascov'')';
EXECUTE IMMEDIATE 'INSERT INTO stations VALUES(''CU-D-A'',''Curtea de Arges'')';

--populating any table related to dispatchers
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(41172,''Teea'',''Cranga'', ''teea.cranga@gmail.com'', ''0734902342'', ''Drumul Osiei 18-28'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(21031,''Alina'',''Popescu'',''alinapopescu22@yahoo.com'',''0775674343'',''Str. Zefirului 23'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(39823,''Alina'',''Vlaicu'',''alina233@gmail.com'',''0776442784'',''Str. Unirii 22-32'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(43058,''Adrian'',''Zarnoianu'',''adrian_z@gmail.com'',''0745566212'',''Str. Preciziei'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(32120,''Bianca'',''Dragan'',''anamaria_dragan@yahoo.com'',''0778348685'',''Str. Ion Minulescu'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(13013,''Andreea'',''Lificiu'',''lificiu.andre@gmail.com'',''0756467245'',''Str. Stejarului'')';
EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(65234,''Ana'',''Tudor'',''antudo@outlook.com'',''0788458212'',''Str. Lujerului'')';

EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(41172,''Admin'',NULL)';
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(21031,''OPERATOR'',41172)'; 
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(39823,''DISPATCHER'',21031)';
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(43058,''DISPATCHER'',21031)';
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(32120,''Guest'',39823)';    
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(13013,''Guest'',43058)';
EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(65234,''Guest'',43058)';

EXECUTE IMMEDIATE 'INSERT INTO disp_salary VALUES(12000,.5, 41172)';
EXECUTE IMMEDIATE 'INSERT INTO disp_salary VALUES(9000,.4, 21031)';
EXECUTE IMMEDIATE 'INSERT INTO disp_salary VALUES(3000,.15, 13013)';

EXECUTE IMMEDIATE 'ALTER TABLE disp_info
ADD first_name varchar2(20)';
EXECUTE IMMEDIATE 'ALTER TABLE disp_info
ADD last_name varchar2(20)';

EXECUTE IMMEDIATE 'UPDATE disp_info di
SET di.first_name=(SELECT d.first_name FROM dispatchers d WHERE d.admin_id=di.disp_id)';

EXECUTE IMMEDIATE 'UPDATE disp_info di
SET di.last_name=(SELECT d.last_name FROM dispatchers d WHERE d.admin_id=di.disp_id)';


EXECUTE IMMEDIATE 'ALTER TABLE dispatchers
DROP COLUMN first_name';

EXECUTE IMMEDIATE 'ALTER TABLE dispatchers
DROP COLUMN last_name';

--before adding anything, i will alter the table so that it accepts the date the train arrives and the destination
EXECUTE IMMEDIATE 'ALTER TABLE route
ADD date_arrival TIMESTAMP DEFAULT SYSTIMESTAMP';
EXECUTE IMMEDIATE 'ALTER TABLE route
ADD destination varchar(10) REFERENCES stations(station_id)';

--populating route
--(the odd ones go to station B, the even ones go back to station A)
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(9201,''PITE'',''R-E9208'',TO_DATE(''03-01-2023'', ''dd-mm-yyyy''),TO_TIMESTAMP(''03-01-2023 14:00'', ''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''03-01-2023 15:41'',''dd-mm-yyyy hh24:mi''),''BUCU-N'')';
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(9202,''BUCU-N'',''R-E9213'',TO_DATE(''03-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''03-01-2023 09:03'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''03-01-2023 10:53'', ''dd-mm-yyyy hh24:mi''),''PITE'')';

EXECUTE IMMEDIATE 'INSERT INTO route VALUES(1501,''BUCU-N'',''IR1581'',TO_DATE(''04-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''04-01-2023 10:12'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''04-01-2023 12:33'',''dd-mm-yyyy hh24:mi''),''CONS'')';
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(1502,''CONS'',''IR1583'',TO_DATE(''07-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''07-01-2023 11:30'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''07-01-2023 14:07'',''dd-mm-yyyy hh24:mi''),''BUCU-N'')';

EXECUTE IMMEDIATE 'INSERT INTO route VALUES(502,''PLOI-V'',''IC531'',TO_DATE(''05-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''05-01-2023 10:42'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''05-01-2023 12:34'',''dd-mm-yyyy hh24:mi''),''BRAS'')';
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(501,''BRAS'',''IC533'',TO_DATE(''05-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''05-01-2023 15:30'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''05-01-2023 17:44'',''dd-mm-yyyy hh24:mi''),''PLOI-V'')';

EXECUTE IMMEDIATE 'INSERT INTO route VALUES(1801,''CRAI'',''IR1824'',TO_DATE(''06-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''06-01-2023 14:10'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''06-01-2023 15:30'',''dd-mm-yyyy hh24:mi''),''VIDE'')';
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(1802,''VIDE'',''IR1826'',TO_DATE(''06-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''08-01-2023 05:54'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''08-01-2023 08:37'',''dd-mm-yyyy hh24:mi''),''CRAI'')';

EXECUTE IMMEDIATE 'INSERT INTO route VALUES(9501,''BASC'',''R9531'',TO_DATE(''08-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''08-01-2023 13:55'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''08-01-2023 14:40'',''dd-mm-yyyy hh24:mi''),''CU-D-A'')';
EXECUTE IMMEDIATE 'INSERT INTO route VALUES(9502,''CU-D-A'',''R9533'',TO_DATE(''05-01-2023'',''dd-mm-yyyy''),TO_TIMESTAMP(''05-01-2023 12:30'',''dd-mm-yyyy hh24:mi''),TO_TIMESTAMP(''05-01-2023 13:13'',''dd-mm-yyyy hh24:mi''),''BASC'')';

--populating delays
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(10,
                        1502,
                        TO_TIMESTAMP(''04-01-2023 12:33'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''04-01-2023 12:40'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''04-01-2023 12:35'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''04-01-2023 12:42'',''dd-mm-yyyy hh24:mi''),
                        ''Unexpected stops until station Cernavoda Pod'',
                        1002,
                        39823)';

--reached bucuresti nord           
 --therefore we don't need departure         \/                
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(11,
                        1502,
                        TO_TIMESTAMP(''04-01-2023 14:07'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''04-01-2023 14:16'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''04-01-2023 14:16'',''dd-mm-yyyy hh24:mi''),   
                        null,                                                    
                        ''Unexpected stops until station Cernavoda Pod'',
                        1002,
                        32120)';
--delay at the departure from craiova
--therefore we don't need a date for arrival     \/
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(12,
                         1801,
                         TO_TIMESTAMP(''06-01-2023 14:10'',''dd-mm-yyyy hh24:mi''), 
                         null,                                               
                         TO_TIMESTAMP(''06-01-2023 14:10'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 14:30'',''dd-mm-yyyy hh24:mi''),
                         ''Waiting for other train to reach Craiova station'',
                         1001,
                         43058
                         )';
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(13,
                         1801,
                         TO_TIMESTAMP(''04-01-2023 14:30'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 14:55'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 14:32'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 14:57'',''dd-mm-yyyy hh24:mi''),
                        ''Unexpected stops until Caracal'',
                        1002,
                        43058
                         )';
                        
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(14,
                         1801,
                         TO_TIMESTAMP(''04-01-2023 15:30'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 15:55'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''04-01-2023 15:55'',''dd-mm-yyyy hh24:mi''),
                         null,
                         ''-'',
                        default,
                        43058
                         )';                 
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(15,
                         9202,
                         TO_TIMESTAMP(''03-01-2023 09:43'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''03-01-2023 09:44'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''03-01-2023 09:44'',''dd-mm-yyyy hh24:mi''),
                         TO_TIMESTAMP(''03-01-2023 09:45'',''dd-mm-yyyy hh24:mi''),
                         ''Small delay at Titu'',
                        default,
                        13013
                         )'; 
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(16,
                         9202,
                         TO_TIMESTAMP(''04-01-2023 10:12'',''dd-mm-yyyy hh24:mi''),
                         null,
                         TO_TIMESTAMP(''04-01-2023 10:13'',''dd-mm-yyyy hh24:mi''),
                         null,
                         ''Broken Train Engine. Passengers will be transfered to another train.'',
                        1003,       
                        13013
                         )'; 
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(17,
                         9501,
                         TO_TIMESTAMP(''08-01-2023 13:55'',''dd-mm-yyyy hh24:mi''),
                         null,
                        TO_TIMESTAMP(''08-01-2023 13:55'',''dd-mm-yyyy hh24:mi''),
                         null,
                         ''Departure was cancelled.'',
                        1004,
                        43058
                         )';   
EXECUTE IMMEDIATE 'INSERT INTO delays VALUES(18,
                         502,
                        TO_TIMESTAMP(''05-01-2023 12:34'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''05-01-2023 12:50'',''dd-mm-yyyy hh24:mi''),
                        TO_TIMESTAMP(''05-01-2023 12:34'',''dd-mm-yyyy hh24:mi''),
                        null,
                         ''Unexpected stops until station Brasov'',
                        1001,
                        39823
                         )';                         
END;
/

--update the rank columns so that all the ranks have capital letters only 
BEGIN
    EXECUTE IMMEDIATE 'UPDATE disp_info
    SET ranks=UPPER(RANKS)';
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || sql%rowcount);
END;
/

--one of the dispatchers wrote the wrong delay code for "Unexpected stops" at the delay number 13. Update the code.
BEGIN
    EXECUTE IMMEDIATE 'UPDATE delays
    SET delay_code=1001
    WHERE delay_id=13';
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || sql%rowcount);
END;
/

--delete the dispatcher with the name Ana Tudor
BEGIN

    EXECUTE IMMEDIATE 'DELETE FROM disp_info
    WHERE first_name=''Ana'' 
    AND last_name=''Tudor''';
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || sql%rowcount);

    EXECUTE IMMEDIATE 'DELETE FROM dispatchers 
    WHERE admin_id=''65234''';
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || sql%rowcount);

END;
/

--add her back
BEGIN
    EXECUTE IMMEDIATE 'INSERT INTO dispatchers VALUES(65234,''antudo@outlook.com'',''0788458212'',''Str. Lujerului'')';
    DBMS_OUTPUT.PUT_LINE('Rows added: ' || sql%rowcount);

    EXECUTE IMMEDIATE 'INSERT INTO disp_info VALUES(65234,''GUEST'',43058,''Ana'',''Tudor'')';
    DBMS_OUTPUT.PUT_LINE('Rows added: ' || sql%rowcount);
END;
/

-- update the salary table by raising the dispatchers's salary using the commision pct column
-- if dispatchers are not in the table, add them with the multiplier 0.1 and add it to the basic salary (3000)
BEGIN

    EXECUTE IMMEDIATE 'MERGE INTO disp_salary s
    USING (SELECT admin_id FROM delays GROUP BY admin_id ORDER BY admin_id) d
    ON (s.disp_id = d.admin_id)
    WHEN MATCHED THEN
    UPDATE SET s.salary = s.salary + s.salary *s.commission_pct
    WHEN NOT MATCHED THEN
    INSERT (s.disp_id, salary, commission_pct)
    VALUES (d.admin_id, 3000 + 3000 * 0.1, 0.1)';

END;
/


--display (using a varray) the trains and when they leave

DECLARE
    TYPE R_REC IS RECORD(
        TRAIN_ID ROUTE.TRAIN_ID%TYPE,
        ROUTE_HOUR ROUTE.ROUTE_HOUR%TYPE
    );
    TYPE T_ARRAY IS VARRAY(30) OF R_REC;
    V T_ARRAY;
    I PLS_INTEGER;
BEGIN
    SELECT TRAIN_ID, ROUTE_HOUR BULK COLLECT INTO V
    FROM ROUTE;
    FOR I IN V.FIRST..V.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('TRAIN ' || V(I).TRAIN_ID|| ' LEAVES AT: '||V(I).ROUTE_HOUR);
    END LOOP;
END;
/

--update the train_capacity number to a train
--if there is no train like the input, write a message
DECLARE
    V_INPUT_TRAIN TRAINS.TRAIN_ID%TYPE := :TRAIN_ID;
BEGIN
    UPDATE TRAINS
    SET TRAIN_CAPACITY = 3
    WHERE TRAIN_ID = V_INPUT_TRAIN;
    IF SQL%NOTFOUND 
        THEN DBMS_OUTPUT.PUT_LINE('THERE IS NO TRAIN WITH ID '|| V_INPUT_TRAIN);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('TRAIN UPDATED SUCCESFULLY.');
    END IF;
END;
/

--make an explicit cursor which explains all the data in the trains table
DECLARE
    CURSOR CUR_TRAINS IS 
    SELECT TRAIN_TYPE, TRAIN_ID, TRAIN_CAPACITY
    FROM TRAINS;
BEGIN
    FOR V_TRAIN_RECORD IN CUR_TRAINS LOOP
        DBMS_OUTPUT.PUT_LINE('THE ' || V_TRAIN_RECORD.TRAIN_TYPE ||' TRAIN, WITH ID: ' || V_TRAIN_RECORD.TRAIN_ID || ' HAS A NUMBER OF ' || V_TRAIN_RECORD.TRAIN_CAPACITY || ' COACHES.');
    END LOOP;
END;
/

--display the first 4 delay explanations
DECLARE
    V_DELAY_EXP DELAYS.DELAY_EXPLANATION%TYPE;
    I NUMBER:=10;
BEGIN
    WHILE I<14 LOOP
        SELECT DELAY_EXPLANATION INTO V_DELAY_EXP FROM DELAYS WHERE DELAY_ID = I;
        DBMS_OUTPUT.PUT_LINE(V_DELAY_EXP);
        I:= I+1;
    END LOOP;
END;
/


--create an explicit cursor which takes the user_ids of those who reported delays on a specific train (use a parameter)
--input is 1502 in the pl/sql block
DECLARE
    CURSOR CUR(P_ROUTE_ID DELAYS.ROUTE_ID%TYPE) IS 
    SELECT ADMIN_ID FROM DELAYS 
    WHERE ROUTE_ID = P_ROUTE_ID;
    R CUR%ROWTYPE;
BEGIN
    OPEN CUR(1502);
    LOOP
        FETCH CUR INTO R;
        EXIT WHEN CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('USER: '||R.ADMIN_ID||' REPORTED ON THIS ROUTE');
    END LOOP;
    CLOSE CUR;
END;
/

--select the trains which leave from a certain station(in this case bucu-n)
--if there are more than two, raise an exception
--if the station doesn't exist/no train leaves from there, raise NO_DATA_FOUND exception
DECLARE
    V_TRAIN NUMBER;
BEGIN
    SELECT TRAIN_ID INTO V_TRAIN FROM ROUTE WHERE STATION_ID='BUCU-N';
    --SELECT TRAIN_ID INTO V_TRAIN FROM ROUTE WHERE STATION_ID='IASI'; --for no_data_found
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('THERE ARE MORE THAN TWO TRAINS WHICH LEAVE FROM BUCU-N'); 
        WHEN NO_DATA_FOUND THEN     
        DBMS_OUTPUT.PUT_LINE('NO TRAIN LEAVES FROM THIS STATION');  
END;
/



--[-----------!!FUNCTIONS & PROCEDURES!!-----------]--


--create a procedure which displays the train and how many minutes of delay it had at both arrival and departure
--if the train has no delay at either of the actions, replace with -1
CREATE OR REPLACE PROCEDURE DELAYS_TRAIN(P_TRAIN_ID ROUTE.TRAIN_ID%TYPE) IS
    CURSOR CUR IS SELECT r.train_id, r.route_id, NVL(ABS(EXTRACT(MINUTE FROM d.actual_arrival-d.expected_arrival)),-1) ARRIVAL,
    NVL(ABS(EXTRACT(MINUTE FROM d.actual_departure-d.expected_departure)),-1) DEPARTURE
    FROM delays d, route r
    WHERE d.route_id=r.route_id
    AND R.TRAIN_ID = P_TRAIN_ID
    ORDER BY r.train_id;
    R CUR%ROWTYPE;
BEGIN
    OPEN CUR;
    FETCH CUR INTO R;
    DBMS_OUTPUT.PUT_LINE('MINUTES OF DELAY AT ARRIVAL: '|| R.ARRIVAL||CHR(10)||'MINUTES OF DELAY AT DEPARTURE: '||R.DEPARTURE);
END;
/
BEGIN
    DELAYS_TRAIN('IR1583');
END;
/


--make a procedure which shows the email of a certain dispatcher using the id. if the id doesn't exist, raise an exception
CREATE OR REPLACE PROCEDURE GET_DISP_DATA(P_DISP_ID DISPATCHERS.ADMIN_ID%TYPE) IS
    CURSOR CUR IS SELECT FIRST_NAME, LAST_NAME, EMAIL, PHONE FROM DISPATCHERS D 
    JOIN DISP_INFO I ON ADMIN_ID = DISP_ID 
    WHERE ADMIN_ID = P_DISP_ID;
    R CUR%ROWTYPE;
    EXCEP EXCEPTION;
    PRAGMA EXCEPTION_INIT(EXCEP,-20000);
BEGIN
    OPEN CUR;
    FETCH CUR INTO R;
    IF CUR%NOTFOUND THEN RAISE EXCEP;
    END IF;
    DBMS_OUTPUT.PUT_LINE(R.FIRST_NAME||' '||R.LAST_NAME||'''S DETAILS: '||R.EMAIL||' '||R.PHONE);
CLOSE CUR;

EXCEPTION 
WHEN EXCEP THEN
    DBMS_OUTPUT.PUT_LINE('DISPATCHER NOT FOUND');
END;
/

BEGIN
--GET_DISP_DATA(10003534534532); --this will raise the exception
GET_DISP_DATA(41172);
END;
/


-- create a procedure, which takes the dispatcher id as a parameter and displays their salary status
-- if the salary is <=5000 the salary is low, if the salary is<=9000, the status is medium, else is high
-- in the anonymous block, call the procedure for a specific id. if it doesn't exist, then raise the proper exception (input is 41172)
CREATE OR REPLACE PROCEDURE SHOW_SALARY_STATS(P_DISP_ID DISP_SALARY.SALARY%TYPE) IS
V_SALARY NUMBER;
BEGIN
    SELECT SALARY INTO V_SALARY 
    FROM DISP_SALARY 
    WHERE DISP_ID=P_DISP_ID;
    CASE 
    WHEN V_SALARY<=5000 THEN 
        DBMS_OUTPUT.PUT_LINE('LOW SALARY');
    WHEN V_SALARY<=9000 THEN 
        DBMS_OUTPUT.PUT_LINE('MEDIUM SALARY');
    ELSE
        DBMS_OUTPUT.PUT_LINE('HIGH SALARY');
    END CASE;
END;
/

DECLARE 
    V_DISP_ID DISP_SALARY.DISP_ID%TYPE := &DISP_ID;
    TYPE R_INFO IS RECORD(
        FIRST_NAME DISP_INFO.FIRST_NAME%TYPE,
        LAST_NAME DISP_INFO.LAST_NAME%TYPE
    );
    T R_INFO;
BEGIN
    SELECT FIRST_NAME, LAST_NAME INTO T FROM DISP_INFO
    WHERE DISP_ID = V_DISP_ID;
    DBMS_OUTPUT.PUT_LINE('DISPATCHER '||T.FIRST_NAME||' '||T.LAST_NAME||' (WITH ID '||V_DISP_ID||')''S STATUS:');
    SHOW_SALARY_STATS(V_DISP_ID);
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE('THIS DISPATCHER DOES NOT EXIST.');
END;
/


-- create a function which returns true/false depending on the status of that train
--(if the train has the delay code 1003/1004, it's cancelled/broken, else, it will reach the final station soon)
--create a table of records to store the delays and the routes which they belong to and show how many trains were cancelled/broken during their rides
CREATE OR REPLACE FUNCTION IS_CANCELLED_OR_BROKEN(P_DELAY_ID DELAYS.DELAY_ID%TYPE) RETURN BOOLEAN IS
V_DELAY DELAYS.DELAY_CODE%TYPE;
BEGIN
    SELECT DELAY_CODE 
    INTO V_DELAY 
    FROM DELAYS 
    WHERE DELAY_ID = P_DELAY_ID; 
    IF V_DELAY IN(1003,1004) THEN
        RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END;
/
DECLARE
    TYPE RECORD_TRAINS IS RECORD(
        R_ROUTE_ID DELAYS.ROUTE_ID%TYPE,
        R_DELAY_ID DELAYS.ROUTE_ID%TYPE  
    );
    TYPE T_NAME IS TABLE OF RECORD_TRAINS INDEX BY PLS_INTEGER;
    V T_NAME;
    I PLS_INTEGER;
    V_NUMBER_CANCELLED_BROKEN NUMBER := 0;
BEGIN
    SELECT ROUTE_ID, DELAY_ID BULK COLLECT INTO V
    FROM DELAYS;
    FOR I IN V.FIRST .. V.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(V(I).R_ROUTE_ID||' WITH DELAY ID:'||V(I).R_DELAY_ID);
        IF IS_CANCELLED_OR_BROKEN(V(I).R_DELAY_ID) THEN
            DBMS_OUTPUT.PUT_LINE('IS CANCELLED/BROKEN.');
            V_NUMBER_CANCELLED_BROKEN:=V_NUMBER_CANCELLED_BROKEN+1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('THERE ARE CURRENTLY '||V_NUMBER_CANCELLED_BROKEN||' BROKEN/CANCELLED TRAINS.');
END;
/


--create two functions: one of them returns the station name the train leaves from and one which returns the name of the station in which it arrives to.
--use them in a plsql block
CREATE OR REPLACE FUNCTION GET_STATION_NAME(P_ROUTE_ID IN ROUTE.ROUTE_ID%TYPE) RETURN VARCHAR2 IS
    P_STATION_NAME STATIONS.STATION_NAME%TYPE;
BEGIN
    SELECT STATION_NAME INTO P_STATION_NAME FROM STATIONS
    WHERE STATION_ID = (SELECT STATION_ID FROM ROUTE WHERE ROUTE_ID = P_ROUTE_ID);
    RETURN P_STATION_NAME;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(GET_STATION_NAME(9201));
END;
/

CREATE OR REPLACE FUNCTION GET_DEST_NAME(P_ROUTE_ID IN ROUTE.ROUTE_ID%TYPE) RETURN VARCHAR2 IS
    P_STATION_NAME STATIONS.STATION_NAME%TYPE;
BEGIN
    SELECT STATION_NAME INTO P_STATION_NAME FROM STATIONS
    WHERE STATION_ID = (SELECT DESTINATION FROM ROUTE WHERE ROUTE_ID = P_ROUTE_ID);
    RETURN P_STATION_NAME;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('TRAIN 9201 HAS ROUTE: '||GET_STATION_NAME(9201)||'-'||GET_DEST_NAME(9201));
END;
/

--[-----------!!PACKAGE!!-----------]--

--create a package
CREATE OR REPLACE PACKAGE PACK_UTILS AS
    
    --gets the full name of the dispatcher
    FUNCTION GET_FULL_NAME(P_DISP_ID IN DISP_INFO.DISP_ID%TYPE) RETURN VARCHAR2;

    --gets the main superior of the user
    FUNCTION GET_SUPERIOR(P_DISP_ID IN DISP_INFO.DISP_ID%TYPE) RETURN VARCHAR2;

    --prints the rank of the user
    PROCEDURE PRINT_RANK(P_DISP_ID DISP_INFO.DISP_ID%TYPE);

END;
/


CREATE OR REPLACE PACKAGE BODY PACK_UTILS AS 

    FUNCTION GET_FULL_NAME(P_DISP_ID IN DISP_INFO.DISP_ID%TYPE) RETURN VARCHAR2 IS
        V_FULL_NAME VARCHAR2(200);
        V_FIRST_NAME VARCHAR2(100);
        V_LAST_NAME VARCHAR2(100);
    BEGIN
        SELECT FIRST_NAME, LAST_NAME 
        INTO V_FIRST_NAME, V_LAST_NAME 
        FROM DISP_INFO
        WHERE DISP_ID = P_DISP_ID;
        V_FULL_NAME := V_FIRST_NAME||' '||V_LAST_NAME;
        RETURN V_FULL_NAME;
    END GET_FULL_NAME;

    FUNCTION GET_SUPERIOR(P_DISP_ID IN DISP_INFO.DISP_ID%TYPE) RETURN VARCHAR2 IS
        V_SUPERIOR_ID DISP_INFO.DISP_ID%TYPE;
        V_FIRST_NAME VARCHAR2(100);
        V_LAST_NAME VARCHAR2(100);
        V_FULL_INFO VARCHAR2(200);
    BEGIN
        SELECT DISP_INFO_ID
        INTO V_SUPERIOR_ID
        FROM DISP_INFO
        WHERE DISP_ID = P_DISP_ID;
        SELECT FIRST_NAME, LAST_NAME
        INTO V_FIRST_NAME, V_LAST_NAME
        FROM DISP_INFO
        WHERE DISP_ID=V_SUPERIOR_ID;
        V_FULL_INFO := ' WITH SUPERIOR: '|| V_SUPERIOR_ID||' '||V_FIRST_NAME||' '||V_LAST_NAME;
        RETURN V_FULL_INFO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            RETURN 'THE USER IS THE ADMIN.';
    END GET_SUPERIOR;

    PROCEDURE PRINT_RANK(P_DISP_ID DISP_INFO.DISP_ID%TYPE) IS
        V_RANKS VARCHAR2(20);
    BEGIN
        SELECT RANKS INTO V_RANKS FROM DISP_INFO
        WHERE DISP_ID = P_DISP_ID;
        DBMS_OUTPUT.PUT_LINE('THE USER''S RANK IS: '|| V_RANKS);
    END PRINT_RANK;

END;
/

--show all the users, their ranks and their superiors
DECLARE
    FULL_NAME VARCHAR2(200);
    SUP_NAME VARCHAR2(200);
BEGIN
    SELECT
    PACK_UTILS.GET_FULL_NAME(DISP_ID), 
    PACK_UTILS.GET_SUPERIOR(DISP_ID) INTO FULL_NAME, SUP_NAME
    FROM DISP_INFO
    WHERE DISP_ID = 21031;
    DBMS_OUTPUT.PUT_LINE(FULL_NAME|| ' '||SUP_NAME);
    PACK_UTILS.PRINT_RANK(21031);
END;
/

--[-----------!!TRIGGERS!!-----------]--

--create a trigger to prevent modifying the salary of guests 
--they have the commission pct of 0.1
CREATE OR REPLACE TRIGGER CH_SALARY_GUESTS AFTER UPDATE OF SALARY ON DISP_SALARY FOR EACH ROW
BEGIN
    IF :NEW.SALARY<>:OLD.SALARY AND :NEW.COMMISSION_PCT = 0.1 THEN
    RAISE_APPLICATION_ERROR(-20001,'WE CAN''T CHANGE THE SALARY');      
   END IF;
END;
/

BEGIN 
    UPDATE DISP_SALARY SET SALARY = 3400 WHERE COMMISSION_PCT=0.1;
END;
/

--create a trigger which prevents adding trains with more thean 10 coaches or less or equal to 0
CREATE OR REPLACE TRIGGER CH_TRAIN_COACHES BEFORE INSERT ON TRAINS FOR EACH ROW
BEGIN
    IF :NEW.TRAIN_CAPACITY < 0 OR :NEW.TRAIN_CAPACITY > 10 THEN
        RAISE_APPLICATION_ERROR(-20001,'THE TRAIN HAS AN INVALID TRAIN CAPACITY.');
    END IF;
END;
/

BEGIN
    INSERT INTO TRAINS VALUES('R10310', 11, 'Regio Express');
END;
/



--create a trigger which prevents adding duplicate dispatchers in the disp_info table 
CREATE OR REPLACE TRIGGER DUP_USER AFTER INSERT OR UPDATE ON DISP_INFO
DECLARE
    V_DUPLICATES NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_DUPLICATES FROM DISP_INFO
    WHERE PACK_UTILS.GET_FULL_NAME(DISP_ID) IN
    (SELECT PACK_UTILS.GET_FULL_NAME(DISP_ID) AS "FULL NAME" 
     FROM DISP_INFO 
     GROUP BY PACK_UTILS.GET_FULL_NAME(DISP_ID) 
     HAVING COUNT(*) > 1
    );

   IF V_DUPLICATES > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'DUPLICATE DISPATCHER NAME FOUND!');
   END IF;
END;
/
BEGIN
    INSERT INTO DISPATCHERS VALUES('23423', 'ABC@GMAIL.COM', '03243242','ASDASDAS');
    INSERT INTO DISP_INFO VALUES('23423','OPERATOR','21031', 'Alina','Vlaicu');
END;
/


--create a trigger which prevents modifying delays
CREATE OR REPLACE TRIGGER INS_SAME_STATION AFTER INSERT OR UPDATE ON ROUTE 
DECLARE
    CURSOR CUR IS SELECT STATION_ID, DESTINATION 
    FROM ROUTE;
    R CUR%ROWTYPE;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO R;
        EXIT WHEN CUR%NOTFOUND;
        IF R.STATION_ID = R.DESTINATION THEN
            RAISE_APPLICATION_ERROR(-20001,'THE TRAIN CANNOT GO TO THE SAME STATION WHERE IT DEPARTS FROM.');
        END IF;
    END LOOP;
    CLOSE CUR;
END;
/

BEGIN
    INSERT INTO ROUTE VALUES(9203,'PITE','R-E9208', TO_DATE('05-01-2023','dd-mm-yyyy'),TO_TIMESTAMP('05-01-2023 10:42','dd-mm-yyyy hh24:mi'),TO_TIMESTAMP('05-01-2023 12:34','dd-mm-yyyy hh24:mi'),'PITE');
END;
/


