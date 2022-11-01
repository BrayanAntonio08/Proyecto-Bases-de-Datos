
CREATE SCHEMA Person;

Create table Person.Person(
	person_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(100) NOT NULL,
	phone_number varchar(50) UNIQUE NOT NULL,
	adress varchar (255) NOT NULL
);
Create table Person.Owner(
	owner_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_owner_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
);
Create table Person.Tenant(
	tenant_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_tenant_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
);
Create table Person.Patient(
	patient_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	reported_illnesses varchar(150) NOT NULL,
	reported_surgeries varchar(150) NOT NULL,
	CONSTRAINT fk_patient_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
);

CREATE SCHEMA Place;

Create table Place.Building(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	service varchar(200) NOT NULL
);
CREATE table Place.Endowment(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY ,
	service_type varchar(200) not null,
	price Integer not null
);

CREATE TABLE Place.Room(
	building_code INTEGER not NULL,
	CONSTRAINT fk_building_room FOREIGN KEY(building_code) 
		REFERENCES Place.Building(code),
	room_number INTEGER not null,
	room_floor INTEGER not null,
	PRIMARY KEY(room_number, room_floor),
	room_id INT GENERATED ALWAYS AS IDENTITY UNIQUE,
	height INTEGER not null,
	widh INTEGER not null,
	windows BIT not null,
	is_consultory BIT not null,
	is_rented BIT not null,
	administration_costs INTEGER NOT NULL,
	rental_date DATE not null,
	last_remodeling DATE not null,
	owner_id INTEGER not null,
	tenant_id INTEGER not null,
	CONSTRAINT fk_room_owner FOREIGN KEY(owner_id) 
		REFERENCES Person.Owner(owner_id),
	CONSTRAINT fk_room_tenant FOREIGN KEY (tenant_id) 
		REFERENCES Person.Tenant(tenant_id)
);

CREATE TABLE Place.Endowment_Room(
	endowment_code INTEGER NOT NULL,
	room_id INTEGER NOT NULL,
	PRIMARY KEY (endowment_code,room_id),
	CONSTRAINT fk_room FOREIGN KEY(room_id) 
		REFERENCES Place.Room(room_id),
	CONSTRAINT fk_endowment FOREIGN KEY(endowment_code) 
		REFERENCES Place.Endowment(code)
);

CREATE TABLE Place.Consulting_Room_Patient(
	entry_date DATE NOT NULL,
	departure_date DATE NOT NULL,
	room_id INTEGER NOT NULL,
	CONSTRAINT fk_room_for_patient FOREIGN KEY(room_id) 
		REFERENCES Place.Room(room_id),
	patient_id INTEGER NOT NULL,
	CONSTRAINT fk_patient_in_room FOREIGN KEY(patient_id) 
		REFERENCES Person.Patient(patient_id),
	CONSTRAINT ck_Consultory_Room 
	CHECK (Place.sp_check_consultory_room(room_id) = B'1')--Procedimiento almacenado para verificar que es consultorio)
);

CREATE SCHEMA Staff;

CREATE TABLE Staff.Staff(
	staff_code INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INTEGER UNIQUE NOT NULL,
	CONSTRAINT fk_person_employee FOREIGN KEY(person_id)
		REFERENCES Person.Person(person_id),
	employment_date DATE NOT NULL,
	working_area VARCHAR(50) NOT NULL,
	job VARCHAR(50) NOT NULL
);

--DROP TABLE Staff.Doctor CASCADE; 

CREATE TABLE Staff.Medical_area(
	area_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(255) UNIQUE,
	doctor_director_code INTEGER NOT NULL UNIQUE
);

CREATE TABLE Staff.Doctor(
	medical_staff_code INTEGER PRIMARY KEY,
	CONSTRAINT fk_doctor_staff_code FOREIGN KEY(medical_staff_code)
		REFERENCES Staff.Staff(staff_code),
	medical_area_specialty INTEGER,
	CONSTRAINT fk_doctor_specialty FOREIGN KEY(medical_area_specialty)
		REFERENCES Staff.Medical_area(area_id)
);

ALTER TABLE staff.Medical_area ADD 
	CONSTRAINT fk_director_doctor FOREIGN KEY(doctor_director_code)
		REFERENCES Staff.Doctor(medical_staff_code);
		
		
CREATE TABLE Staff.Operating_floor(
	floor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	charge_nurse_staff_code INTEGER UNIQUE
);

CREATE Table Staff.Nurse(
	medical_staff_code INTEGER PRIMARY KEY,
	CONSTRAINT fk_nurse_staff_code FOREIGN KEY(medical_staff_code)
		REFERENCES Staff.Staff(staff_code),
	
	medical_area_id INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT fk_area_employee FOREIGN KEY(medical_area_id)
		REFERENCES Staff.Medical_area(area_id),
	
	operating_floor_id INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT fk_operating_floor FOREIGN KEY(operating_floor_id)
		REFERENCES Staff.Operating_floor(floor_id)
);

ALTER TABLE Staff.Operating_floor ADD
	CONSTRAINT fk_nurse_in_charge FOREIGN KEY(charge_nurse_staff_code)
		REFERENCES Staff.Nurse(medical_staff_code);
		
CREATE TABLE Staff.Auxiliar(
	medical_staff_code INTEGER PRIMARY KEY,
	CONSTRAINT fk_auxiliar_staff_code FOREIGN KEY(medical_staff_code)
		REFERENCES Staff.Staff(staff_code),
	
	medical_area_id INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT fk_area_employee FOREIGN KEY(medical_area_id)
		REFERENCES Staff.Medical_area(area_id),
	
	operating_floor_id INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT fk_operating_floor FOREIGN KEY(operating_floor_id)
		REFERENCES Staff.Operating_floor(floor_id)
)

CREATE SCHEMA Service

Create table service(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	service_type varchar(200) NOT NULL
)

Create table edificio(
code Integer primary key,
service varchar(200)
)

Create table medicine(
medicine_id Integer primary key,
name varchar(200)
)