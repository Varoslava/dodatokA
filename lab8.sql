CREATE OR ALTER PROCEDURE dbo.sp_SetReleaseForm
    @ReleaseFormId INT = NULL OUTPUT,
    @Name NVARCHAR(50) = NULL
AS
BEGIN

IF @ReleaseFormId IS NULL
BEGIN
    IF @Name IS NULL OR @Name = N''
        THROW 51000, 'Name cannot be NULL or empty.', 1;
END

BEGIN TRY

    IF @ReleaseFormId IS NULL
    BEGIN
        INSERT INTO ReleaseForm([Name])
        VALUES(@Name);

        SET @ReleaseFormId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE ReleaseForm
        SET [Name] = ISNULL(@Name, [Name])
        WHERE ReleaseFormId = @ReleaseFormId;
    END

END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

END



DECLARE @id INT;
EXEC sp_SetReleaseForm @id OUTPUT, N'Краплі';
SELECT @id;





CREATE OR ALTER PROCEDURE dbo.sp_SetMedicine
    @MedicineId INT = NULL OUTPUT,
    @Name NVARCHAR(50) = NULL,
    @Dose INT = NULL,
    @ReleaseFormId INT = NULL,
    @Price INT = NULL,
    @Producer NVARCHAR(50) = NULL
AS
BEGIN

BEGIN
    IF @Name IS NULL OR @Name = N''
        THROW 51000, 'Name cannot be NULL or empty for INSERT.', 1;

    IF @Dose IS NULL
        THROW 51001, 'Dose cannot be NULL for INSERT.', 1;

    IF @ReleaseFormId IS NULL
        THROW 51002, 'ReleaseFormId cannot be NULL for INSERT.', 1;

    IF @Price IS NULL
        THROW 51003, 'Price cannot be NULL for INSERT.', 1;

    IF @Producer IS NULL OR @Producer = N''
        THROW 51004, 'Producer cannot be NULL or empty for INSERT.', 1;
END

BEGIN TRY

    IF @MedicineId IS NULL
    BEGIN
        INSERT INTO Medicine([Name], Dose, ReleaseFormId, Price, Producer)
        VALUES(@Name, @Dose, @ReleaseFormId, @Price, @Producer);

        SET @MedicineId = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE Medicine
        SET [Name] = ISNULL(@Name, [Name]),
            Dose = ISNULL(@Dose, Dose),
            ReleaseFormId = ISNULL(@ReleaseFormId, ReleaseFormId),
            Price = ISNULL(@Price, Price),
            Producer = ISNULL(@Producer, Producer)
        WHERE MedicineId = @MedicineId;
    END

END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

END

DECLARE @id1 INT; 
EXEC sp_SetMedicine @id1 OUTPUT, N'Нурофен', 60, 2, 15, N'Фармак'; 
SELECT @id1; 

DECLARE @id2 INT; 
EXEC sp_SetMedicine @id2 OUTPUT, N'Нурофен', 60, 2, 15, N''; 
SELECT @id2; 

EXEC sp_SetMedicine @MedicineId = 5, @Price = 85;





CREATE OR ALTER PROCEDURE dbo.sp_SetSupplier
    @SupplierId INT = NULL OUTPUT,
    @Name NVARCHAR(100) = NULL,
    @ContactPerson NVARCHAR(50) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Address NVARCHAR(200) = NULL
AS
BEGIN

IF @SupplierId IS NULL
BEGIN
    IF @Name IS NULL OR @Name = N''
        THROW 51000, 'Supplier name cannot be NULL or empty.', 1;
END

BEGIN TRY

    IF @SupplierId IS NULL
    BEGIN
        INSERT INTO Suppliers([Name], ContactPerson, Phone, [Address])
        VALUES(@Name, @ContactPerson, @Phone, @Address);

        SET @SupplierId = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE Suppliers
    SET [Name] = ISNULL(@Name, [Name]),
        ContactPerson = ISNULL(@ContactPerson, ContactPerson),
        Phone = ISNULL(@Phone, Phone),
        [Address] = ISNULL(@Address, [Address])
    WHERE SupplierId = @SupplierId;

END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

END



DECLARE @id1 INT;

EXEC sp_SetSupplier 
    @SupplierId = @id1 OUTPUT,
    @Name = N'ТОВ "ФармаКо Плюс"',
    @ContactPerson = N'Сергій Марчук',
    @Phone = N'+380671234567',
    @Address = N'м. Київ, просп. Перемоги, 55';

SELECT @id1;



DECLARE @id2 INT;
EXEC sp_SetSupplier 
     @SupplierId = @id2 OUTPUT,
     @Name = N'',
     @ContactPerson = N'Валерій Макарчук',
     @Phone = N'+380931112233',
     @Address = N'м. Київ, просп. Перемоги, 12';
SELECT @id2 AS SecondSupplierId;

EXEC sp_SetSupplier @SupplierId = 3, @Phone = N'+380777777700';




CREATE OR ALTER PROCEDURE dbo.sp_SetDetailsSupply
    @DetailsSupplyId INT = NULL OUTPUT,
    @MedicineId INT = NULL,
    @Count INT = NULL,
    @ExpirationDate DATE = NULL,
    @Price INT = NULL,
    @SupplyId INT = NULL,
    @CellId INT = NULL
AS
BEGIN
IF @DetailsSupplyId IS NULL
BEGIN
    IF @MedicineId IS NULL
        THROW 51000, 'MedicineId cannot be NULL for INSERT.', 1;

    IF NOT EXISTS (SELECT 1 FROM Medicine WHERE MedicineId = @MedicineId)
        THROW 51001, 'Invalid MedicineId (no such medicine).', 1;

    IF @Count IS NULL
        THROW 51002, 'Count cannot be NULL for INSERT.', 1;

    IF @ExpirationDate IS NULL OR @ExpirationDate = N''
        THROW 51003, 'ExpirationDate cannot be NULL for INSERT.', 1;

    IF @Price IS NULL
        THROW 51004, 'Price cannot be NULL for INSERT.', 1;

    IF @SupplyId IS NULL
        THROW 51005, 'SupplyId cannot be NULL for INSERT.', 1;

    IF NOT EXISTS (SELECT 1 FROM Supply WHERE SupplyId = @SupplyId)
        THROW 51006, 'Invalid SupplyId (no such supply).', 1;
END

BEGIN TRY
    IF @DetailsSupplyId IS NULL
    BEGIN
        INSERT INTO DetailsSupply(MedicineId, [Count], ExpirationDate, Price, SupplyId, CellId)
        VALUES(@MedicineId, @Count, @ExpirationDate, @Price, @SupplyId, @CellId);

        SET @DetailsSupplyId = SCOPE_IDENTITY();
        RETURN;
    END

    UPDATE DetailsSupply
    SET 
        MedicineId = ISNULL(@MedicineId, MedicineId),
        [Count] = CASE 
                     WHEN @Count IS NOT NULL THEN [Count] + @Count
                     ELSE [Count]
                  END,
        ExpirationDate = ISNULL(@ExpirationDate, ExpirationDate),
        Price = ISNULL(@Price, Price),
        SupplyId = ISNULL(@SupplyId, SupplyId),
        CellId = ISNULL(@CellId, CellId)
    WHERE DetailsSupplyId = @DetailsSupplyId;

END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

END



DECLARE @id INT;
EXEC sp_SetDetailsSupply 
    @DetailsSupplyId = @id OUTPUT,
    @MedicineId = 5,
    @Count = 120,
    @ExpirationDate = '2027-01-01',
    @Price = 55,
    @SupplyId = 3,
    @CellId = 2;
SELECT @id;

EXEC sp_SetDetailsSupply 
    @DetailsSupplyId = 1,
    @Count = 5;



