-- CREACIÓN DE PROCEDIMIENTOS ALMACENADOS

/*	
	Function to validate that a room is a consultory
*/
CREATE OR REPLACE FUNCTION Place.sp_check_consultory_room(room_id int)
RETURNS BIT
AS
$BODY$

	SELECT R.is_consultory
	FROM Place.Room R
	WHERE R.room_id = room_id
	
$BODY$ LANGUAGE 'sql';


/*
	Base function to make the trigger that updates the working area of
	staff members
*/
CREATE OR REPLACE FUNCTION Staff.sp_set_working_area()
RETURNS TRIGGER
AS
$BODY$
DECLARE
	area VARCHAR(50) := Staff.get_working_area(new.job);
	staff_id INTEGER := new.staff_code;
BEGIN

	if(NEW.working_area <> area OR OLD.working_area <> area) then
		UPDATE Staff.Staff
		SET working_area = area
		WHERE staff_code = NEW.staff_code;
		
		RETURN NEW;
	ELSE
		RETURN NEW;
	end if;
	
END;
$BODY$ LANGUAGE plpgsql;

/*
	Trigger added to Staff members so that the working_area colum
	works as a computed one
*/
CREATE OR REPLACE TRIGGER tr_set_working_area
    AFTER INSERT OR UPDATE 
    ON Staff.Staff
    FOR EACH ROW
    EXECUTE FUNCTION staff.sp_set_working_area();

/*
	Logical function that compares the job so that it returns the area respective
	to that job
*/
CREATE OR REPLACE FUNCTION Staff.get_working_area(new_job VARCHAR(50))
RETURNS VARCHAR(50)
AS
$BODY$
	BEGIN
	
		IF(new_job like '%Accounting%'
		   OR new_job like '%Finance%'
		   OR new_job like '%Human Resources%') THEN
			RETURN 'Administrative';
			
		ELSE 
			IF(new_job like '%Doctor%'
			   OR new_job like '%Nurse%'
			   OR new_job like '%Auxiliar%') THEN
				RETURN 'Medical';
			
			ELSE 
				IF(new_job like '%Cook%'
				   OR new_job like '%Cleaner%'
				   OR new_job like '%pharmacist%'
				   OR new_job like '%Guard%') THEN 
					RETURN 'Operating';
		
				ELSE
					RETURN 'Undefined';
				END IF;
			END IF;
		END IF;
	END; --fin de función
$BODY$ LANGUAGE 'plpgsql';

/*
	Validate that a staff code is not registered in more than one medical table 
	(doctor, nurse, auxiliar)
*/
CREATE OR REPLACE FUNCTION Staff.ck_asigned_job(staff_id INTEGER)
RETURNS BIT
AS
$BODY$
	BEGIN
		IF(
			(SELECT D.medical_staff_code
			FROM staff.Doctor D
			WHERE D.medical_staff_code = staff_id) IS NOT NULL
		) THEN
			RETURN B'1';
		END IF;
		
		IF(
			(SELECT N.medical_staff_code
			FROM staff.Nurse N
			WHERE N.medical_staff_code = staff_id) IS NOT NULL
		) THEN
			RETURN B'1';
		END IF;
		
		IF(
			(SELECT A.medical_staff_code
			FROM staff.Auxiliar A
			WHERE A.medical_staff_code = staff_id) IS NOT NULL
		) THEN
			RETURN B'1';
		END IF;
		
		RETURN B'0';
	END;
$BODY$ LANGUAGE plpgsql;


/*  Function that updates the job of a staff member to doctor */
CREATE OR REPLACE FUNCTION Staff.sp_set_doctor_staff() 
RETURNS TRIGGER
AS
$BODY$
DECLARE
	staff_id INTEGER := new.medical_staff_code;
BEGIN
	UPDATE Staff.staff
	SET job = 'Doctor'
	WHERE staff_code = staff_id;
	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

-- Create the trigger that is actioned by doctor insertion
CREATE OR REPLACE TRIGGER tr_doctor_staff
	AFTER INSERT
    ON Staff.Doctor
    FOR EACH ROW
    EXECUTE FUNCTION staff.sp_set_doctor_staff();

/*  Function that updates the job of a staff member to nurse */
CREATE OR REPLACE FUNCTION Staff.sp_set_nurse_staff() 
RETURNS TRIGGER
AS
$BODY$
DECLARE
	staff_id INTEGER := new.medical_staff_code;
BEGIN
	UPDATE Staff.staff
	SET job = 'Nurse'
	WHERE staff_code = staff_id;
	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

-- Create the trigger that is actioned by nurse insertion
CREATE OR REPLACE TRIGGER tr_nurse_staff
	AFTER INSERT
    ON Staff.Nurse
    FOR EACH ROW
    EXECUTE FUNCTION staff.sp_set_nurse_staff();
	
/*  Function that updates the job of a staff member to auxiliar */
CREATE OR REPLACE FUNCTION Staff.sp_set_auxiliar_staff() 
RETURNS TRIGGER
AS
$BODY$
DECLARE
	staff_id INTEGER := new.medical_staff_code;
BEGIN
	UPDATE Staff.staff
	SET job = 'Auxiliar'
	WHERE staff_code = staff_id;
	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

-- Create the trigger that is actioned by auxiliar insertion
CREATE OR REPLACE TRIGGER tr_auxiliar_staff
	AFTER INSERT
    ON Staff.Auxiliar
    FOR EACH ROW
    EXECUTE FUNCTION staff.sp_set_auxiliar_staff();
	
	
/*
	Create a function that updates the specialty of a doctor, based on medical area data
*/
CREATE OR REPLACE FUNCTION Staff.sp_update_doctor_specialty()
RETURNS TRIGGER
AS
$BODY$
DECLARE
	area_name VARCHAR(255) := NEW.name;
	doctor_id INTEGER      := NEW.doctor_director_code;
BEGIN
	IF(doctor_id IS NOT NULL) THEN
		UPDATE Staff.Doctor
		SET medical_area_specialty = area_name
		WHERE medical_staff_code = doctor_id;
	END IF;
	RETURN NEW;
END;

$BODY$ LANGUAGE plpgsql;
	
--Create the trigger that updates doctors
CREATE OR REPLACE TRIGGER tr_set_doctor_specialty
	AFTER INSERT OR UPDATE
	ON Staff.Medical_area
	FOR EACH ROW
	EXECUTE FUNCTION Staff.sp_update_doctor_specialty();
	
	
/*
	Create a function that updates the specialty of a doctor, based on medical area data
*/
CREATE OR REPLACE FUNCTION Staff.sp_update_nurse_floor()
RETURNS TRIGGER
AS
$BODY$
DECLARE
	floor_id INTEGER := NEW.floor_id;
	nurse_id INTEGER := NEW.charge_nurse_staff_code;
BEGIN
	IF(nurse_id IS NOT NULL) THEN
		UPDATE Staff.Nurse
		SET operating_floor_id = floor_id
		WHERE medical_staff_code = nurse_id;
	END IF;
	RETURN NEW;
END;

$BODY$ LANGUAGE plpgsql;
	
--Create the trigger that updates doctors
CREATE OR REPLACE TRIGGER tr_set_nurse_floor
	AFTER INSERT OR UPDATE
	ON Staff.operating_floor
	FOR EACH ROW
	EXECUTE FUNCTION Staff.sp_update_nurse_floor();
	
	
/*
	Creates a function that counts the amount od visit cards respective to an hopitalization
	and set it to the amount of doctor visits the patient have had
*/
CREATE OR REPLACE FUNCTION Service.sp_count_doctor_visits(hospitalization_id INTEGER)
RETURNS INTEGER
AS
$BODY$
DECLARE
	amount_visits INTEGER; 
BEGIN
	amount_visits := (
		SELECT COUNT(visit_card_id)
		FROM Service.Visit_card
		WHERE hospitalization_service_record_id = hospitalization_id
	);
	
	RETURN amount_visits;
END;

$BODY$ LANGUAGE plpgsql IMMUTABLE;