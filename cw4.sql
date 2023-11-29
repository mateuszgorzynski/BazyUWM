-- 1

CREATE OR REPLACE FUNCTION PobierzNazwePracy(p_job_id JOBS.JOB_ID%TYPE)
RETURN JOBS.JOB_TITLE%TYPE
IS
    v_job_title JOBS.JOB_TITLE%TYPE;
BEGIN
	SELECT JOB_TITLE INTO v_job_title FROM JOBS WHERE JOB_ID = p_job_id;
	IF v_job_title IS NULL THEN
		RAISE_APPLICATION_ERROR(-20009, 'Nie znaleziono pracy o podanym ID.');
	ELSE
		RETURN v_job_title;
	END IF;
END PobierzNazwePracy;

DECLARE
	v_nazwa_pracy JOBS.JOB_TITLE%TYPE;
BEGIN
	v_nazwa_pracy := PobierzNazwePracy(1);
	DBMS_OUTPUT.PUT_LINE('Nazwa pracy: ' || v_nazwa_pracy);
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
END;

-- 2

CREATE OR REPLACE FUNCTION roczne_zarobki(p_employee_id NUMBER) RETURN NUMBER IS
    v_roczne_zarobki NUMBER;
    v_wynagrodzenie NUMBER;
    v_premia NUMBER;
BEGIN
    SELECT SALARY, NVL(COMMISSION_PCT, 0)
    INTO v_wynagrodzenie, v_premia
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = p_employee_id;

    v_roczne_zarobki := v_wynagrodzenie * 12 + v_wynagrodzenie * v_premia;

    RETURN v_roczne_zarobki;
END roczne_zarobki;

DECLARE
    v_wynik NUMBER;
BEGIN
	v_wynik := roczne_zarobki(101);
    DBMS_OUTPUT.PUT_LINE('Roczne zarobki pracownika: ' || v_wynik);
END;
