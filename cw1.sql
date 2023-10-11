CREATE TABLE jobs (
    job_id INT,
    job_title VARCHAR2(50),
    min_salary NUMBER(10,2),
    max_salary NUMBER(10,2)
);

ALTER TABLE jobs
    ADD PRIMARY KEY (job_id);

CREATE TABLE regions (
    regions_id INT,
    region_name VARCHAR2(50)
);

ALTER TABLE regions
	ADD PRIMARY KEY (regions_id);

CREATE TABLE countries (
    country_id INT,
    country_name VARCHAR2(50),
    regions_id INT,
    FOREIGN KEY (regions_id) REFERENCES regions(regions_id)
);

ALTER TABLE countries
	ADD PRIMARY KEY (country_id);

CREATE TABLE locations (
    location_id INT,
    street_address VARCHAR2(50),
    postal_code VARCHAR2(50),
    city VARCHAR2(50),
    state_province VARCHAR2(50),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

ALTER TABLE locations
	ADD PRIMARY KEY (location_id);
	
CREATE TABLE departments (
    department_id INT,
    department_name VARCHAR2(50),
    manager_id INT,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

ALTER TABLE departments
	ADD PRIMARY KEY (department_id);


CREATE TABLE employees (
	employee_id INT,
	first_name varchar2(50),
	last_name varchar2(50),
	email varchar2(50),
	phone_number varchar2(50),
	hire_date DATE,
	job_id INT,
	FOREIGN KEY (job_id) REFERENCES jobs(job_id),
	salary NUMBER(10,2),
	commission_pct NUMBER (10,2)
	manager_id INT,
	department id INT,
	FOREIGN KEY (department_id) REFERENCES departments(department_id),
);

ALTER TABLE employees
	ADD PRIMARY KEY (employee_id),
	FOREIGN KEY (manager_id) REFERENCES employees_id(employee_id);
	

ALTER TABLE departments
	FOREIGN KEY (manager_id) REFERENCES employee_id(manager_id);


CREATE TABLE job_history (
	employee_id INT,
	start_date DATE,
	end_date DATE,
	job_id INT,
	department_id INT
);

ALTER TABLE job_history
	FOREIGN KEY (employee_id) REFERENCES employees_id(employee_id),
	ADD PRIMARY KEY (employee_id),
	ADD PRIMARY KEY (start_date);

