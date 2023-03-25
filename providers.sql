-- List of hospital providers

/*
CREATE TABLE providers(
provider_empID VARCHAR(6) UNIQUE PRIMARY KEY,
provider_fname VARCHAR(25) NOT NULL,
provider_lname VARCHAR(25) NOT NULL,
provider_credentials ENUM('MD', 'NP', 'PA') NOT NULL, -- NP = Nurse practioner, PA = Physician Assistent 
provider_service_line ENUM('Emergency', 'Trauma','Internal Med', 'Cardiology') NOT NULL
*/

-- Emergency Room Providers
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('ed01', 'Paul', 'Blanco', 'MD', 'Emergency'); 
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('ed02', 'Janet', 'Lee', 'NP', 'Emergency');
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('ed03', 'David', 'Bement', 'MD', 'Emergency');
-- Trauma Providers
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('TACS01', 'Gene', 'Moore', 'MD', 'Trauma');     
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('TACS02', 'Eve', 'Rosen', 'MD', 'Trauma');
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('TACS03', 'Marcus', 'Weaver', 'MD', 'Trauma');             
-- Internal Medicine providers
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('IM01', 'Alexi', 'Morrison', 'MD', 'Internal Med');             
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('IM02', 'Peter', 'Pons', 'PA', 'Internal Med');
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('IM03', 'Jennifer', 'Pena', 'MD', 'Internal Med');             
-- Cardiology Providers
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('CARDS01', 'Jason', 'Lynch', 'MD', 'Cardiology');             
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('CAR02', 'Sean', 'Michael', 'NP', 'Cardiology');             
INSERT INTO providers(provider_empID, provider_fname, provider_lname, provider_credentials, provider_service_line)
	VALUES('CAR03', 'Alexandra', 'Rosenbaum', 'NP', 'Cardiology');             
    
