-- CREACIÓN DE PROCEDIMIENTOS ALMACENADOS

CREATE OR REPLACE FUNCTION Place.sp_check_consultory_room(room_id int)
RETURNS BIT
AS
$BODY$

	SELECT R.is_consultory
	FROM Place.Room R
	WHERE R.room_id = room_id
	
$BODY$ LANGUAGE 'sql';



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

CREATE OR REPLACE TRIGGER tr_set_working_area
    AFTER INSERT OR UPDATE 
    ON Staff.Staff
    FOR EACH ROW
    EXECUTE FUNCTION staff.sp_set_working_area();



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


