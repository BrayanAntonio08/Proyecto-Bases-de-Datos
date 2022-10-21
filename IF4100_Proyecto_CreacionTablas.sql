
CREATE SCHEMA Person

Create table Person.Person(
	person_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(100) NOT NULL,
	phone_number varchar(50) UNIQUE NOT NULL,
	adress varchar (255) NOT NULL
)

CREATE SCHEMA Place

CREATE table Place.Endowment(
	CODE GENERATED AS IDENTITY PRIMARY KEY ,
	service_type varchar(200) not null,
	price Integer not null
)

CREATE SCHEMA Staff

CREATE SCHEMA Service


Create table service(
code Integer primary key,
service_type varchar(200)
)
Create table edificio(
code Integer primary key,
service varchar(200)
)
Create table medicine(
medicine_id Integer primary key,
name varchar(200)
)