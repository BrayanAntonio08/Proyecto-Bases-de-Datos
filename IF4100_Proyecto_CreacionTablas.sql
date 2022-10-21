
CREATE SCHEMA Person
/*
Create table Person.Person(
	person_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(100) NOT NULL,
	phone_number varchar(50) UNIQUE NOT NULL,
	adress varchar (255) NOT NULL
)
Create table Person.Owner(
	owner_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_owner_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
)
Create table Person.Tenant(
	tenant_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	CONSTRAINT fk_tenant_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
)
Create table Person.Patient(
	patient_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	person_id INT UNIQUE NOT NULL,
	reported_illnesses varchar(150) NOT NULL,
	reported_surgeries varchar(150) NOT NULL,
	CONSTRAINT fk_patient_person 
		FOREIGN KEY (person_id)
		REFERENCES Person.Person(person_id)
)
*/ --tables are already created

--CREATE SCHEMA Place
/*
Create table Place.Building(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	service varchar(200) NOT NULL
)
CREATE table Place.Endowment(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY ,
	service_type varchar(200) not null,
	price Integer not null
)
Create table Place.Room(
	building_code INT,
	CONSTRAINT fk_building_room
		FOREIGN KEY (building_code)
		REFERENCES Place.Building(code),
	room_id INT GENERATED ALWAYS AS IDENTITY,
	number int not null,
	floor int not null,
	CONSTRAINT pk_number_at_floor UNIQUE(number,floor),
	lenght int not null,
	width int not null,
	windows bit not null,
	is_consultory bit not null,
	is_rented bit not null,
	administration_costs int not null,
	rental_date date not null,
	last_remodeling date not null,
	owner_id int not null,
	tenant_id int not null,
	CONSTRAINT fk_owner_of_room 
		FOREIGN KEY(owner_id)
		REFERENCES Person.Owner(owner_id),
	CONSTRAINT fk_tenant_of_room 
		FOREIGN KEY(tenant_id)
		REFERENCES Person.Tenant(tenant_id)
)
*/
--CREATE SCHEMA Staff




CREATE SCHEMA Service
/*
Create table Service.Service(
	code INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	service_type varchar(200) UNIQUE NOT NULL
)
Create table Service.Medicine(
	medicine_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(200) UNIQUE NOT NULL
)
*/
