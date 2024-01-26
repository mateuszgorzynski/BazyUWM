-- 1

CREATE FUNCTION get_job_title(p_job_id jobs.job_id%TYPE)
RETURN jobs.job_title%TYPE IS
    v_job_title jobs.job_title%TYPE;
BEGIN
    SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
    RETURN v_job_title;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie ma takiej pracy');
END;

-- 2

CREATE FUNCTION get_annual_salary(p_emp_id employees.employee_id%TYPE)
RETURN NUMBER IS
    v_annual_salary NUMBER;
BEGIN
    SELECT (salary * 12) + (salary * commission_pct) INTO v_annual_salary FROM employees WHERE employee_id = p_emp_id;
    RETURN v_annual_salary;
END;

-- 3

CREATE FUNCTION get_area_code(p_phone employees.phone_number%TYPE)
RETURN VARCHAR2 IS
    v_area_code VARCHAR2(3);
BEGIN
    v_area_code := SUBSTR(p_phone, INSTR(p_phone, '(', 1, 1) + 1, INSTR(p_phone, ')', 1, 1) - INSTR(p_phone, '(', 1, 1) - 1);
    RETURN v_area_code;
END;

-- 4

CREATE FUNCTION change_case(p_str VARCHAR2)
RETURN VARCHAR2 IS
    v_new_str VARCHAR2(100);
BEGIN
    v_new_str := UPPER(SUBSTR(p_str, 1, 1)) || LOWER(SUBSTR(p_str, 2, LENGTH(p_str) - 2)) || UPPER(SUBSTR(p_str, -1));
    RETURN v_new_str;
END;

-- 5

CREATE FUNCTION pesel_to_birthdate(p_pesel VARCHAR2)
RETURN DATE IS
    v_birthdate DATE;
BEGIN
    v_birthdate := TO_DATE(SUBSTR(p_pesel, 5, 2) || SUBSTR(p_pesel, 3, 2) || SUBSTR(p_pesel, 1, 2), 'RRMMDD');
    RETURN v_birthdate;
END;

-- 6

CREATE FUNCTION get_counts(p_country_name countries.country_name%TYPE)
RETURN VARCHAR2 IS
    v_emp_count NUMBER;
    v_dept_count NUMBER;
BEGIN
    SELECT COUNT(DISTINCT e.employee_id), COUNT(DISTINCT d.department_id) INTO v_emp_count, v_dept_count
    FROM employees e JOIN departments d ON e.department_id = d.department_id
                     JOIN locations l ON d.location_id = l.location_id
                     JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;
    RETURN 'Liczba pracowników: ' || v_emp_count || ', Liczba departamentów: ' || v_dept_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podany kraj nie istnieje');
END;

-- TWORZENIE PACZEK
-- 1
CREATE OR REPLACE PACKAGE my_package AS
    FUNCTION get_job_title(p_job_id jobs.job_id%TYPE) RETURN jobs.job_title%TYPE;
    FUNCTION get_annual_salary(p_emp_id employees.employee_id%TYPE) RETURN NUMBER;
    FUNCTION get_area_code(p_phone employees.phone_number%TYPE) RETURN VARCHAR2;
    FUNCTION change_case(p_str VARCHAR2) RETURN VARCHAR2;
    FUNCTION pesel_to_birthdate(p_pesel VARCHAR2) RETURN DATE;
    FUNCTION get_counts(p_country_name countries.country_name%TYPE) RETURN VARCHAR2;
END my_package;

CREATE OR REPLACE PACKAGE BODY my_package AS
    FUNCTION get_job_title(p_job_id jobs.job_id%TYPE)
    RETURN jobs.job_title%TYPE IS
        v_job_title jobs.job_title%TYPE;
    BEGIN
        SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
        RETURN v_job_title;
    END get_job_title;

    FUNCTION get_annual_salary(p_emp_id employees.employee_id%TYPE)
    RETURN NUMBER IS
        v_annual_salary NUMBER;
    BEGIN
      SELECT (salary * 12) + (salary * commission_pct) INTO v_annual_salary FROM employees WHERE employee_id = p_emp_id;
        RETURN v_annual_salary;
    END get_annual_salary;

    FUNCTION get_area_code(p_phone employees.phone_number%TYPE)
    RETURN VARCHAR2 IS
        v_area_code VARCHAR2(3);
    BEGIN
        v_area_code := SUBSTR(p_phone, INSTR(p_phone, '(', 1, 1) + 1, INSTR(p_phone, ')', 1, 1) - INSTR(p_phone, '(', 1, 1) - 1);
        RETURN v_area_code;
    END get_area_code;

    FUNCTION change_case(p_str VARCHAR2)
    RETURN VARCHAR2 IS
        v_new_str VARCHAR2(100);
    BEGIN
        v_new_str := UPPER(SUBSTR(p_str, 1, 1)) || LOWER(SUBSTR(p_str, 2, LENGTH(p_str) - 2)) || UPPER(SUBSTR(p_str, -1));
        RETURN v_new_str;
    END change_case;

    FUNCTION pesel_to_birthdate(p_pesel VARCHAR2)
    RETURN DATE IS
        v_birthdate DATE;
    BEGIN
        v_birthdate := TO_DATE(SUBSTR(p_pesel, 5, 2) || SUBSTR(p_pesel, 3, 2) || SUBSTR(p_pesel, 1, 2), 'RRMMDD');
        RETURN v_birthdate;
    END pesel_to_birthdate;

    FUNCTION get_counts(p_country_name countries.country_name%TYPE)
    RETURN VARCHAR2 IS
        v_emp_count NUMBER;
        v_dept_count NUMBER;
    BEGIN
        SELECT COUNT(DISTINCT e.employee_id), COUNT(DISTINCT d.department_id) INTO v_emp_count, v_dept_count
        FROM employees e JOIN departments d ON e.department_id = d.department_id
                         JOIN locations l ON d.location_id = l.location_id
                         JOIN countries c ON l.country_id = c.country_id
        WHERE c.country_name = p_country_name;
        RETURN 'Liczba pracowników: ' || v_emp_count || ', Liczba departamentów: ' || v_dept_count;
    END get_counts;
END my_package;



-- 2

CREATE OR REPLACE PACKAGE regions_package AS
    PROCEDURE create_region(p_region_id regions.region_id%TYPE, p_region_name regions.region_name%TYPE);
    PROCEDURE read_region(p_region_id regions.region_id%TYPE);
    PROCEDURE update_region(p_region_id regions.region_id%TYPE, p_region_name regions.region_name%TYPE);
    PROCEDURE delete_region(p_region_id regions.region_id%TYPE);
END regions_package;

CREATE OR REPLACE PACKAGE BODY regions_package AS
    PROCEDURE create_region(p_region_id regions.region_id%TYPE, p_region_name regions.region_name%TYPE) IS
    BEGIN
        INSERT INTO regions(region_id, region_name) VALUES(p_region_id, p_region_name);
    END create_region;

    PROCEDURE read_region(p_region_id regions.region_id%TYPE) IS
        v_region_name regions.region_name%TYPE;
    BEGIN
        SELECT region_name INTO v_region_name FROM regions WHERE region_id = p_region_id;
        DBMS_OUTPUT.PUT_LINE('Region name: ' || v_region_name);
    END read_region;

    PROCEDURE update_region(p_region_id regions.region_id%TYPE, p_region_name regions.region_name%TYPE) IS
    BEGIN
        UPDATE regions SET region_name = p_region_name WHERE region_id = p_region_id;
    END update_region;

    PROCEDURE delete_region(p_region_id regions.region_id%TYPE) IS
    BEGIN
        DELETE FROM regions WHERE region_id = p_region_id;
    END delete_region;
END regions_package;
