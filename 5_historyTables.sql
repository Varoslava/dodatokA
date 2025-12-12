USE Pharmacy;
GO

-- Medicine
    
ALTER TABLE Medicine
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_Medicine_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_Medicine_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Medicine
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Medicine_History));
GO

    
-- Supply
    
ALTER TABLE Supply
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_Supply_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_Supply_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Supply
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Supply_History));
GO


-- DetailsSupply

ALTER TABLE DetailsSupply
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_DetailsSupply_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_DetailsSupply_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE DetailsSupply
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DetailsSupply_History));
GO

    
-- Pharmacists

ALTER TABLE Pharmacists
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_Pharmacists_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_Pharmacists_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Pharmacists
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Pharmacists_History));
GO


-- Clients

ALTER TABLE Clients
ADD ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
    CONSTRAINT DF_Clients_ValidFrom DEFAULT SYSUTCDATETIME(),
ValidTo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
    CONSTRAINT DF_Clients_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);
GO

ALTER TABLE Clients
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Clients_History));
GO

    
-- Medicine

UPDATE Medicine
SET Price = CASE 
    WHEN MedicineId = 19 THEN 40
    WHEN MedicineId = 20 THEN 60
END
WHERE MedicineId IN (19, 20);

SELECT *
FROM Medicine
WHERE Name = N'Ібупрофен';

SELECT *
FROM Medicine_History
WHERE Name = N'Ібупрофен';

UPDATE Medicine
SET Dose = 130
WHERE MedicineId = 3;

SELECT *, ValidFrom, ValidTo
FROM Medicine
WHERE MedicineId = 3;

SELECT *
FROM Medicine_History

WHERE MedicineId = 3;


-- Supply

UPDATE Supply
SET TotalPrice = CASE
    WHEN SupplyId = 1 THEN 5500
    WHEN SupplyId = 3 THEN 4500
END
WHERE SupplyId IN (1, 3);

SELECT *
FROM Supply
WHERE SupplyId IN (1, 3);

SELECT *
FROM Supply_History
WHERE SupplyId IN (1, 3);


-- DetailsSupply

UPDATE DetailsSupply
SET Price = CASE
    WHEN DetailsSupplyId = 2 THEN 35
    WHEN DetailsSupplyId = 5 THEN 110
END,
    [Count] = CASE
    WHEN DetailsSupplyId = 2 THEN 160
    WHEN DetailsSupplyId = 5 THEN 95
END
WHERE DetailsSupplyId IN (2, 5);

SELECT *
FROM DetailsSupply
WHERE DetailsSupplyId IN (2, 5);

SELECT *
FROM DetailsSupply_History
WHERE DetailsSupplyId IN (2, 5);


-- Pharmacists

UPDATE Pharmacists
SET Position = CASE
    WHEN PharmacistId = 2 THEN N'Старший фармацевт'
    WHEN PharmacistId = 7 THEN N'Фармацевт'
END,
    WorkSchedule = CASE
    WHEN PharmacistId = 2 THEN N'Пн–Пт 09:00–18:00'
    WHEN PharmacistId = 7 THEN N'Пн–Сб 10:00–17:00'
END
WHERE PharmacistId IN (2, 7);

SELECT *
FROM Pharmacists
WHERE PharmacistId IN (2, 7);

SELECT *
FROM Pharmacists_History
WHERE PharmacistId IN (2, 7);


-- Clients

UPDATE Clients
SET DiscountType = CASE
    WHEN ClientId = 1 THEN N'Накопичувальна'
    WHEN ClientId = 4 THEN N'Пільгова (студентська)'
END,
    Phone = CASE
    WHEN ClientId = 1 THEN N'+380501000000'
    WHEN ClientId = 4 THEN N'+380991234567'
END
WHERE ClientId IN (1, 4);

SELECT *
FROM Clients
WHERE ClientId IN (1, 4);

SELECT *
FROM Clients_History
WHERE ClientId IN (1, 4);
