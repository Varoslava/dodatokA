USE Pharmacy;
GO

/* Зовнішні ключі (FOREIGN KEYS) */

ALTER TABLE Medicine
ADD CONSTRAINT FK_Medicine_ReleaseForm FOREIGN KEY (ReleaseFormId) REFERENCES ReleaseForm(ReleaseFormId);

ALTER TABLE DetailsSupply
ADD CONSTRAINT FK_DetailsSupply_Medicine FOREIGN KEY (MedicineId) REFERENCES Medicine(MedicineId);

ALTER TABLE DetailsSupply
ADD CONSTRAINT FK_DetailsSupply_Supply FOREIGN KEY (SupplyId) REFERENCES Supply(SupplyId);

ALTER TABLE DetailsSupply
ADD CONSTRAINT FK_DetailsSupply_Storage FOREIGN KEY (CellId) REFERENCES Storage(CellId);

ALTER TABLE Supply
ADD CONSTRAINT FK_Supply_Supplier FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_Pharmacist FOREIGN KEY (PharmacistId) REFERENCES Pharmacists(PharmacistId);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_Client FOREIGN KEY (ClientId) REFERENCES Clients(ClientId);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_SaleDetails FOREIGN KEY (SaleDetailsId) REFERENCES SaleDetails(SaleDetailsId);

ALTER TABLE SaleDetails
ADD CONSTRAINT FK_SaleDetails_Medicine FOREIGN KEY (MedicineId) REFERENCES Medicine(MedicineId);
GO


/* Унікальні обмеження (UNIQUE) */

ALTER TABLE Suppliers
ADD CONSTRAINT UQ_Suppliers_Phone UNIQUE (Phone);

ALTER TABLE Pharmacists
ADD CONSTRAINT UQ_Pharmacists_Login UNIQUE (Login);

ALTER TABLE Clients
ADD CONSTRAINT UQ_Clients_Phone UNIQUE (Phone);

ALTER TABLE Medicine
ADD CONSTRAINT UQ_Medicine_NameDose UNIQUE ([Name], Dose, ReleaseFormId, Producer);

ALTER TABLE Storage
ADD CONSTRAINT UQ_Storage_CellNumber UNIQUE (CellNumber);
GO


/* Перевірки (CHECK) */

-- Імена, де не допускаються цифри

ALTER TABLE Pharmacists
WITH NOCHECK
ADD CONSTRAINT CK_Pharmacists_LastName CHECK (Surname NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%'),
CONSTRAINT CK_Pharmacists_FirstName CHECK (Name NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%'),
CONSTRAINT CK_Pharmacists_Paternal CHECK (Paternal NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%');

ALTER TABLE Clients
WITH NOCHECK
ADD CONSTRAINT CK_Clients_LastName CHECK (Surname NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%'),
CONSTRAINT CK_Clients_FirstName CHECK (Name NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%'),
CONSTRAINT CK_Clients_Paternal CHECK (Paternal NOT LIKE '%[^A-Za-zА-Яа-яЇїІіЄєҐґ'' ]%');

-- Телефони лише з цифр, у форматі 0XXXXXXXXX або +380XXXXXXXXX
ALTER TABLE Suppliers
WITH NOCHECK
ADD CONSTRAINT CK_Suppliers_PhoneFormat CHECK (
    Phone LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR Phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);

ALTER TABLE Pharmacists
ADD CONSTRAINT CK_Pharmacists_PhoneFormat CHECK (
    Phone LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR Phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);

ALTER TABLE Clients
ADD CONSTRAINT CK_Clients_PhoneFormat CHECK (
    Phone LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR Phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);

-- Дата народження у межах (для прикладу)
ALTER TABLE Clients
ADD CONSTRAINT CK_Clients_BirthDate CHECK (BirthDate BETWEEN '1955-01-01' AND GETDATE());

-- Ціна, кількість, доза — позитивні
ALTER TABLE Medicine
ADD CONSTRAINT CK_Medicine_Price CHECK (Price > 0);

ALTER TABLE Medicine
ADD CONSTRAINT CK_Medicine_Dose CHECK (Dose > 0);

ALTER TABLE DetailsSupply
ADD CONSTRAINT CK_DetailsSupply_Count CHECK ([Count] > 0);

ALTER TABLE DetailsSupply
ADD CONSTRAINT CK_DetailsSupply_Price CHECK (Price > 0);

ALTER TABLE DetailsSupply
ADD CONSTRAINT CK_DetailsSupply_ExpirationDate CHECK ([ExpirationDate] > GETDATE());

ALTER TABLE Sales
ADD CONSTRAINT CK_Sales_TotalAmount CHECK (TotalAmount > 0);
GO


/* Значення за замовчуванням (DEFAULT) */

ALTER TABLE Clients
ADD CONSTRAINT DF_Clients_HasPrescription DEFAULT 0 FOR HasPrescription;
ALTER TABLE Clients
ADD CONSTRAINT DF_Clients_DiscountType DEFAULT N'Немає' FOR DiscountType;

ALTER TABLE Suppliers
ADD CONSTRAINT DF_Suppliers_ContactPerson DEFAULT N'Не вказано' FOR ContactPerson;

ALTER TABLE Pharmacists
ADD CONSTRAINT DF_Pharmacists_WorkSchedule DEFAULT N'Пн–Пт 09:00–18:00' FOR WorkSchedule;

ALTER TABLE DetailsSupply
ADD CONSTRAINT DF_DetailsSupply_CellId DEFAULT 1 FOR CellId;

GO


/* Перевірка обмежень */

-- Помилка: цифри в імені
INSERT INTO Clients (Surname, Name, Paternal, BirthDate, Phone, HasPrescription, DiscountType, Address)
VALUES (N'Іванов1', N'Петро', N'Іванович', '1990-05-05', N'0509998888', 0, N'Накопичувальна', N'м. Київ');

INSERT INTO Clients (Surname, Name, Paternal, BirthDate, Phone, HasPrescription, DiscountType, Address)
VALUES (N'Іванов!', N'Петро', N'Іванович', '1990-05-05', N'0509998889', 0, N'Накопичувальна', N'м. Київ');

-- Помилка: неправильний формат телефону
INSERT INTO Suppliers ([Name], Phone, Address, ContactPerson)
VALUES (N'Дарниця', N'054567A', N'м. Київ', N'Марія Іванівна');

-- Помилка: дата придатності у минулому
INSERT INTO DetailsSupply (MedicineId, [Count], [ExpirationDate], Price, SupplyId, CellId)
VALUES (1, 10, '2020-01-01', 50, 1, 1);

-- Помилка: негативна ціна
INSERT INTO Medicine ([Name], Dose, ReleaseFormId, Price, Producer)
VALUES (N'Тестова негативна ціна', 100, 1, -10, N'Дарниця');

-- Помилка: дублювання телефону
INSERT INTO Clients (Surname, Name, Paternal, BirthDate, Phone, HasPrescription, DiscountType, Address)
VALUES (N'Повтор', N'Телефон', N'Клієнт', '1995-07-07', N'+380991334455', 1, N'Бонусна', N'м. Львів');

-- Коректна вставка
INSERT INTO Clients (Surname, Name, Paternal, BirthDate, Phone, HasPrescription, DiscountType, Address)
VALUES (N'Коректний', N'Клієнт', N'Перевірка', '1985-03-10', N'+380507778899', 1, N'Бонусна', N'м. Київ');

GO

SELECT * FROM Suppliers WHERE  NOT(   Phone LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'OR 
Phone LIKE '+380[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

-- DELETE FROM Suppliers WHERE SupplierID = 6