CREATE DATABASE Pharmacy;

USE Pharmacy;

CREATE TABLE ReleaseForm(
    ReleaseFormId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE Medicine(
    MedicineId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    Dose INT NOT NULL,
    ReleaseFormId INT NOT NULL,
    Price INT NOT NULL,
    Producer NVARCHAR(50) NOT NULL
);

CREATE TABLE DetailsSupply(
    DetailsSupplyId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    MedicineId INT NOT NULL,
    [Count] INT NOT NULL,
    [ExpirationDate] DATE NOT NULL,
    Price INT NOT NULL,
    SupplyId INT NOT NULL,
    CellId INT
);

CREATE TABLE Supply(
    SupplyId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SupplierId INT NOT NULL,
    [Date] DATE NOT NULL,
    TotalPrice INT
);

CREATE TABLE Suppliers(
    SupplierId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(50),
    Phone NVARCHAR(20),
    [Address] NVARCHAR(200)
);

CREATE TABLE Pharmacists (
    PharmacistId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Surname NVARCHAR(100) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    Paternal NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    WorkSchedule NVARCHAR(100),
    [Login] NVARCHAR(50) NOT NULL
);

CREATE TABLE Clients (
    ClientId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Surname NVARCHAR(100) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    Paternal NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    Phone NVARCHAR(20),
    HasPrescription BIT,
    DiscountType NVARCHAR(50),
    [Address] NVARCHAR(200)
);

CREATE TABLE Storage(
    CellId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    CellNumber INT NOT NULL
);

CREATE TABLE SaleDetails(
    SaleDetailsId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    MedicineId INT NOT NULL,
    MedicineCount INT NOT NULL
);

CREATE TABLE Sales(
    SaleId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [Date] DATE NOT NULL,
    [Time] TIMESTAMP NOT NULL,
    PharmacistId INT NOT NULL,
    ClientId INT,
    SaleDetailsId INT NOT NULL,
    TotalAmount INT NOT NULL
);
