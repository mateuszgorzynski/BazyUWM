ALTER SESSION SET CURRENT_SCHEMA = GORZYNSKIM;

-- 1 i 2
DECLARE
	numer_max NUMBER;
	nowy_numer_departamentu NUMBER;
	typ_pola_departamentu DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
	SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;
	nowy_numer_departamentu := numer_max + 10;
	INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
	VALUES (nowy_numer_departamentu, typ_pola_departamentu);

	UPDATE DEPARTMENTS
	SET LOCATION_ID = 3000
	WHERE DEPARTMENT_ID = nowy_numer_departamentu;
	DBMS_OUTPUT.PUT_LINE('Dodano nowy departament o numerze ' || nowy_numer_departamentu || ' i nazwie ' || typ_pola_departamentu);
END;

-- 3

CREATE TABLE nowa (
  wartosc VARCHAR2(10)
);

DECLARE
  v_wartosc VARCHAR2(10);
BEGIN
  v_wartosc := '1';
  FOR i IN 1..10 LOOP
    IF v_wartosc <> '4' AND v_wartosc <> '6' THEN
      INSERT INTO nowa (wartosc) VALUES (v_wartosc);
    END IF;
    v_wartosc := TO_CHAR(TO_NUMBER(v_wartosc) + 1);
  END LOOP;
END;

-- 4

DECLARE
  kraj_info countries%ROWTYPE;
BEGIN
  SELECT * INTO kraj_info FROM countries WHERE country_id = 'CA';
  DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || kraj_info.country_name);
  DBMS_OUTPUT.PUT_LINE('ID regionu: ' || kraj_info.region_id);
END;


-- 5 i 6

DECLARE
    TYPE DepartamentyTab IS TABLE OF DEPARTMENTS%ROWTYPE INDEX BY BINARY_INTEGER;
    v_departamenty DepartamentyTab;
BEGIN
    FOR i IN 1..100 LOOP
        SELECT * INTO v_departamenty(i) FROM DEPARTMENTS WHERE DEPARTMENT_ID = i * 10;
    END LOOP;

    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Numer departamentu: ' || v_departamenty(i * 10).DEPARTMENT_ID || 
                             ', Nazwa departamentu: ' || v_departamenty(i * 10).DEPARTMENT_NAME || 
                             ', Lokalizacja: ' || v_departamenty(i * 10).LOCATION_ID);
    END LOOP;
END;

-- 7

DECLARE
    CURSOR wynagrodzenie IS
        SELECT e.LAST_NAME, e.SALARY
        FROM EMPLOYEES e
        WHERE e.DEPARTMENT_ID = 50;

    v_nazwisko EMPLOYEES.LAST_NAME%TYPE;
    v_wynagrodzenie EMPLOYEES.SALARY%TYPE;
BEGIN
    OPEN wynagrodzenie;

    LOOP
        FETCH wynagrodzenie INTO v_nazwisko, v_wynagrodzenie;
        EXIT WHEN wynagrodzenie%NOTFOUND;

        IF v_wynagrodzenie > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_nazwisko || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_nazwisko || ' - dać podwyżkę');
        END IF;
    END LOOP;

    CLOSE wynagrodzenie;
END;

-- 8

=DECLARE
    CURSOR zarobki_kursor (p_min_zarobki NUMBER, p_max_zarobki NUMBER, p_czesc_imienia VARCHAR2) IS
        SELECT e.FIRST_NAME, e.LAST_NAME, e.SALARY
        FROM EMPLOYEES e
        WHERE e.SALARY BETWEEN p_min_zarobki AND p_max_zarobki
        AND UPPER(SUBSTR(e.FIRST_NAME, 1, 1)) = UPPER(p_czesc_imienia);

    v_imie EMPLOYEES.FIRST_NAME%TYPE;
    v_nazwisko EMPLOYEES.LAST_NAME%TYPE;
    v_zarobki EMPLOYEES.SALARY%TYPE;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 1000-5000 i imieniem zaczynającym się na "A" lub "a":');
    FOR rekord IN zarobki_kursor(1000, 5000, 'a') LOOP
        v_imie := rekord.FIRST_NAME;
        v_nazwisko := rekord.LAST_NAME;
        v_zarobki := rekord.SALARY;
        DBMS_OUTPUT.PUT_LINE(v_imie || ' ' || v_nazwisko || ' - Zarobki: ' || v_zarobki);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 5000-20000 i imieniem zaczynającym się na "U" lub "u":');
    FOR rekord IN zarobki_kursor(5000, 20000, 'u') LOOP
        v_imie := rekord.FIRST_NAME;
        v_nazwisko := rekord.LAST_NAME;
        v_zarobki := rekord.SALARY;
        DBMS_OUTPUT.PUT_LINE(v_imie || ' ' || v_nazwisko || ' - Zarobki: ' || v_zarobki);
    END LOOP;
END;
/

-- 9 a)
CREATE OR REPLACE PROCEDURE DodajStanowisko(
    p_job_id JOBS.JOB_ID%TYPE,
    p_job_title JOBS.JOB_TITLE%TYPE
) AS
BEGIN
    SELECT COUNT(*) INTO num_jobs FROM JOBS WHERE JOB_ID = p_job_id;
    IF num_jobs > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Stanowisko o podanym ID już istnieje.');
    ELSE
        INSERT INTO JOBS (JOB_ID, JOB_TITLE) VALUES (p_job_id, p_job_title);
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Wystąpił błąd podczas dodawania stanowiska: ' || SQLERRM);
END DodajStanowisko;

-- b)

CREATE OR REPLACE PROCEDURE ModyfikujStanowisko(
    p_job_id JOBS.JOB_ID%TYPE,
    p_new_job_title JOBS.JOB_TITLE%TYPE
) AS
BEGIN
    SELECT COUNT(*) INTO num_jobs FROM JOBS WHERE JOB_ID = p_job_id;
    IF num_jobs = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nie znaleziono stanowiska o podanym ID.');
    ELSE
        UPDATE JOBS SET JOB_TITLE = p_new_job_title WHERE JOB_ID = p_job_id;
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Wystąpił błąd podczas modyfikacji stanowiska: ' || SQLERRM);
END ModyfikujStanowisko;

-- c)

CREATE OR REPLACE PROCEDURE UsunStanowisko(
    p_job_id JOBS.JOB_ID%TYPE
) AS
BEGIN
    SELECT COUNT(*) INTO num_jobs FROM JOBS WHERE JOB_ID = p_job_id;
    IF num_jobs = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nie znaleziono stanowiska o podanym ID.');
    ELSE
        DELETE FROM JOBS WHERE JOB_ID = p_job_id;
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20006, 'Wystąpił błąd podczas usuwania stanowiska: ' || SQLERRM);
END UsunStanowisko;

-- d)

CREATE OR REPLACE PROCEDURE PobierzZarobkiNazwisko(
    p_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_zarobki OUT EMPLOYEES.SALARY%TYPE,
    p_nazwisko OUT EMPLOYEES.LAST_NAME%TYPE
) AS
BEGIN
    SELECT SALARY, LAST_NAME INTO p_zarobki, p_nazwisko FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
END PobierzZarobkiNazwisko;

-- e)

CREATE OR REPLACE PROCEDURE DodajPracownika(
    p_first_name EMPLOYEES.FIRST_NAME%TYPE,
    p_last_name EMPLOYEES.LAST_NAME%TYPE,
    p_salary EMPLOYEES.SALARY%TYPE DEFAULT 0,
    p_department_id EMPLOYEES.DEPARTMENT_ID%TYPE DEFAULT 0
) AS
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Wynagrodzenie pracownika jest zbyt wysokie.');
    ELSE
        INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID)
        VALUES (EMPLOYEES_SEQ.NEXTVAL, p_first_name, p_last_name, p_salary, p_department_id);
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20008, 'Wystąpił błąd podczas dodawania pracownika: ' || SQLERRM);
END DodajPracownika;


