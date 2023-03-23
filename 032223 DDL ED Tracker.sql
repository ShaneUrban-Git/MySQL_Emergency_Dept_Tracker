/* 
The purpose of this database is to provider a free resource for anyone interested in learning MySQL.
	Also, please provide feedback as I am a novice writing SQL code, so this database is meant to teach myself new skills 
    as it is for others to have a free resource to learn SQL coding. 

The below code can be ran in the MySQL Workbench environment to create a rudimentary database for tracking patients
	seen in an emergency department (ED). I decided to build a database to track emergency room patients as I have been working
	in emergency medicine for the last 20 years. Currently, I manage a trauma research lab at the University of Colorado Hospital,
	but I have extensive experience at the bedside as an EMT, paramedic, and registered nurse. Therefore, it is my goal that others will find
    this database interesting as I have tried to make the patients as 'real' as possible. I will provide clinical insights were appropriate 
    so others without clinical knowledge feel more engaged with the database, and hopefully find it interesting. 

Kind regards, 
Shane Urban
surban.github@gmail.com
*/             

CREATE SCHEMA ed_tracker;
USE ed_tracker;

# ** Normally, AUTO_INCREMENT would be used to assign PRIMARY KEYS; 
#	however, for the sake of reporducibility all PRIMARY KEYS and FOREIGN KEYS will be manually assigned.**  
 
-- The provider table includes emergency department providers and other service lines in the event a patient is admitted
-- 	to the hospital. 
 CREATE TABLE providers(
provider_empID VARCHAR(6) UNIQUE PRIMARY KEY,
provider_fname VARCHAR(25) NOT NULL,
provider_lname VARCHAR(25) NOT NULL,
provider_credentials ENUM('MD', 'NP', 'PA') NOT NULL, -- NP = Nurse practioner, PA = Physician Assistent 
provider_service_line ENUM('Emergency', 'Trauma', 'Ortho', 'Neuro', 'Internal Med', 'Cardiology') NOT NULL
-- Service lines are the provider's specialty/training
)
;

DESC providers;
 
CREATE TABLE emergency_dept(
  encounter_id INT UNSIGNED UNIQUE PRIMARY KEY,
  mrn INT UNSIGNED NOT NULL, -- Unique number assigned to each patient. However, each patient may be seen in the ED more than once, so this was not used as the primary key
  pt_fname VARCHAR(25) NOT NULL, -- Patient first name
  pt_lname VARCHAR(25) NOT NULL, -- Patient last name 
  gender VARCHAR(1), -- allowing nulls and blanks for query examples later. 
  age INT UNSIGNED, -- allowing nulls to provide opportunies to query to null values later.
  chief_complaint VARCHAR(25) NOT NULL, -- Patient's complaint/reason for being seen.
  datetime_arrival DATETIME NOT NULL,
  provider_empID VARCHAR(6) NOT NULL,
CONSTRAINT ed_provider_empID_fk FOREIGN KEY (provider_empID)
REFERENCES providers (provider_empID)
  )
  ;

  DESC emergency_dept;
  
  -- Creating table to record vital signs. 
  -- 	Each patient can have numerous vital signs assessed throughout their hospital stay. 
  -- 	However, not every vital sign will be assessed at every timepoint, so nulls will be allowed.
  CREATE TABLE vital_signs(
  vital_signs_id INT UNSIGNED UNIQUE PRIMARY KEY,
  systolicBP INT UNSIGNED,
  diastolicBP INT UNSIGNED,
  pulse INT UNSIGNED,
  gcs INT UNSIGNED, 
  -- gcs = Glasgow Coma Scale (GCS). GCS is a measure of a patient's responsiveness measured using a 3-15 scale (3 = unresponsive; 15 = normal mentation)
  -- https://www.glasgowcomascale.org/ 
  temp double(3,1), -- measured in celcius.
  datetime_vitals DATETIME NOT NULL,
  encounter_id INT UNSIGNED,
CONSTRAINT pt_vitals_fk FOREIGN KEY (encounter_id)
REFERENCES emergency_dept (encounter_id)
)
;

DESC vital_signs;
  
/*Each patient will have numerous procedures, and each procedure needs to have an ordering provider.
	
Abbreviations: ED = Emergency Dept.; OR = Operating Room; Cathlab = Cardiac Catheterization Lab;
			   ICU = Intensive Care Unit; Radiology = Medical Imaging
*/ 
CREATE TABLE procedures(
procedure_id INT UNSIGNED UNIQUE PRIMARY KEY,
procedure_code VARCHAR(15) NOT NULL,
procedure_name VARCHAR(25) NOT NULL,
procedure_location ENUM ('ED', 'OR','Cathlab', 'ICU', 'Floor', 'Radiology') NOT NULL,
datetime_procedure DATETIME NOT NULL,
encounter_id INT UNSIGNED NOT NULL,
provider_empID VARCHAR(6) NOT NULL, -- this is the ordering provider
CONSTRAINT ordering_provider_fk FOREIGN KEY (provider_empID)
REFERENCES providers (provider_empID),
CONSTRAINT patient_procedure_fk FOREIGN KEY (encounter_id)
REFERENCES emergency_dept (encounter_id)
)
;

DESC procedures;

 

CREATE TABLE hospital_admission(
admission_id INT UNSIGNED UNIQUE  PRIMARY KEY,
floor_name ENUM ('Floor', 'ICU', 'Telemetry', 'Med-Surg', 'ED') NOT NULL DEFAULT 'ED', -- Default ED as patient not admitted will only be seen in the ED. 
datetime_admission DATETIME NOT NULL,
admission_diagnosis VARCHAR(25),
admitting_provider_id INT UNSIGNED UNIQUE,
CONSTRAINT admission_provider FOREIGN KEY (admitting_provider_id)
REFERENCES admitting_provider (admitting_provider_id)
)
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
;

DESC hospital_admission; 

INSERT INTO hospital_admission (admission_id, floor_name, datetime_admission, admission_diagnosis, admitting_provider_id)
	VALUES (null, "Telemetry", "2023-01-01 05:00", " ", 1);

SELECT * FROM hospital_admission;

/* Creating table for hospital discharge information.
	Patients can be discharged directly from the ED or whatever floor they go to.
		Home = Routine discharge
        Death = Patient died
		LTAC = Long Term Care Facility
        SNF = Skilled Nursing Facility
        Transfer = Transfered to outside hospital 
        AMA = Against Medical Advice
    */ 

DROP TABLE IF EXISTS hospital_discharge;

CREATE TABLE hospital_discharge(
discharge_id INT UNSIGNED UNIQUE PRIMARY KEY,
dc_location ENUM ('Home', 'Death', 'LTAC', 'SNF', 'Transfer', 'AMA'), -- will allow nulls to demonstrate code to select nulls and blanks.
datetime_dc DATETIME, 
patient_id INT UNSIGNED UNIQUE,
admitting_provider_id INT UNSIGNED UNIQUE, 
CONSTRAINT discharging_provider_fk FOREIGN KEY (admitting_provider_id)
REFERENCES admitting_provider (admitting_provider_id),
CONSTRAINT patient_discharge_fk FOREIGN KEY (patient_id)
REFERENCES emergency_dept (patient_id)
)
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
;

DESC hospital_discharge;

INSERT INTO hospital_discharge (discharge_id, dc_location, datetime_dc, patient_id, admitting_provider_id)
	VALUES (null, 'Home', '2023-01-06', 1, 1);

SELECT * FROM hospital_discharge;

-- Creating table for final dianoses. Patients have to be discharged from the hospital in order to have any final diagnoses.
DROP TABLE IF EXISTS diagnosis;

CREATE TABLE diagnosis(
diagnosis_id INT UNSIGNED UNIQUE PRIMARY KEY,
diagnosis_code VARCHAR(10) NOT NULL,
diagnosis_name VARCHAR(25) NOT NULL,
patient_id INT UNSIGNED NOT NULL,
discharge_id INT UNSIGNED NOT NULL,
CONSTRAINT patient_diagnosis_fk FOREIGN KEY (patient_id)
REFERENCES emergency_dept (patient_id),
CONSTRAINT discharge_diagnosis_fk FOREIGN KEY (discharge_id)
REFERENCES hospital_discharge (discharge_id)
)
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
;

DESC diagnosis;


INSERT INTO diagnosis (diagnosis_id, diagnosis_code, diagnosis_name, patient_id, discharge_id)
	VALUES(null, 'ANG', 'Angina', 1, 1);

SELECT * FROM diagnosis;