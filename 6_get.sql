CREATE OR ALTER PROCEDURE dbo.sp_GetMedicine
    @MedicineId INT = NULL,
    @Name NVARCHAR(50) = NULL,
    @Producer NVARCHAR(50) = NULL,
    @ReleaseFormId INT = NULL,
    @PriceFrom INT = NULL,
    @PriceTo INT = NULL,

    @PageSize INT = 20,
    @PageNumber INT = 1,

    @SortColumn VARCHAR(128) = 'MedicineId',
    @SortDirection BIT = 0              
AS
BEGIN
    SET NOCOUNT ON;

    IF @MedicineId IS NOT NULL
       AND NOT EXISTS(SELECT 1 FROM Medicine WHERE MedicineId = @MedicineId)
    BEGIN
        PRINT 'Incorrect value of @MedicineId';
        RETURN;
    END

    IF @ReleaseFormId IS NOT NULL
       AND NOT EXISTS(SELECT 1 FROM ReleaseForm WHERE ReleaseFormId = @ReleaseFormId)
    BEGIN
        PRINT 'Incorrect value of @ReleaseFormId';
        RETURN;
    END

    ;WITH Stock AS (
        SELECT 
            DS.MedicineId,

            STRING_AGG(CAST(S.CellNumber AS NVARCHAR(20)), ', ') AS CellNumbers,

            SUM(DS.[Count]) AS TotalCount
        FROM DetailsSupply DS
        LEFT JOIN Storage S ON DS.CellId = S.CellId
        GROUP BY DS.MedicineId
    )

    SELECT 
        M.MedicineId,
        M.[Name],
        M.Dose,
        M.ReleaseFormId,
        RF.[Name] AS ReleaseForm,
        M.Price,
        M.Producer,

        CASE WHEN St.TotalCount IS NULL OR St.TotalCount = 0 
             THEN NULL
             ELSE St.CellNumbers
        END AS CellNumber,

        CASE WHEN St.TotalCount IS NULL OR St.TotalCount = 0 
             THEN NULL
             ELSE St.TotalCount
        END AS StockCount

    FROM Medicine M
    JOIN ReleaseForm RF ON M.ReleaseFormId = RF.ReleaseFormId
    LEFT JOIN Stock St ON M.MedicineId = St.MedicineId

    WHERE
        (@MedicineId IS NULL OR M.MedicineId = @MedicineId)
        AND (@Name IS NULL OR M.[Name] LIKE @Name + '%')
        AND (@Producer IS NULL OR M.Producer LIKE @Producer + '%')
        AND (@ReleaseFormId IS NULL OR M.ReleaseFormId = @ReleaseFormId)
        AND (@PriceFrom IS NULL OR M.Price >= @PriceFrom)
        AND (@PriceTo IS NULL OR M.Price <= @PriceTo)

    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'MedicineId' THEN RIGHT('0000000' + CAST(M.MedicineId AS VARCHAR(10)), 10)
                WHEN 'Name'       THEN M.[Name]
                WHEN 'Dose'       THEN RIGHT('0000000' + CAST(M.Dose AS VARCHAR(10)), 10)
                WHEN 'Price'      THEN RIGHT('0000000' + CAST(M.Price AS VARCHAR(10)), 10)
                WHEN 'Producer'   THEN M.Producer
            END
        END ASC,

        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'MedicineId' THEN RIGHT('0000000' + CAST(M.MedicineId AS VARCHAR(10)), 10)
                WHEN 'Name'       THEN M.[Name]
                WHEN 'Dose'       THEN RIGHT('0000000' + CAST(M.Dose AS VARCHAR(10)), 10)
                WHEN 'Price'      THEN RIGHT('0000000' + CAST(M.Price AS VARCHAR(10)), 10)
                WHEN 'Producer'   THEN M.Producer
            END
        END DESC

    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO



EXEC sp_GetMedicine @PageSize = 10, @PageNumber = 1;
EXEC sp_GetMedicine @Name = N'Ібуп';
EXEC sp_GetMedicine @Producer = N'Фармак';
EXEC sp_GetMedicine @PriceFrom = 50, @PriceTo = 80;
EXEC sp_GetMedicine 
    @SortColumn = 'Price',
    @SortDirection = 1;
EXEC sp_GetMedicine @MedicineId = 7;


CREATE OR ALTER PROCEDURE dbo.sp_GetSuppliers
    @SupplierId INT = NULL,
    @Name NVARCHAR(100) = NULL,
    @ContactPerson NVARCHAR(50) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @Address NVARCHAR(200) = NULL,

    @PageSize INT = 20,
    @PageNumber INT = 1,

    @SortColumn VARCHAR(128) = 'SupplierId',
    @SortDirection BIT = 0        
AS
BEGIN
    SET NOCOUNT ON;

    IF @SupplierId IS NOT NULL
       AND NOT EXISTS(SELECT 1 FROM Suppliers WHERE SupplierId = @SupplierId)
    BEGIN
        PRINT 'Incorrect value of @SupplierId';
        RETURN;
    END

    SELECT
        S.SupplierId,
        S.[Name],
        S.ContactPerson,
        S.Phone,
        S.[Address]
    FROM Suppliers S
    WHERE
        (@SupplierId IS NULL OR S.SupplierId = @SupplierId)
        AND (@Name IS NULL OR S.[Name] LIKE @Name + '%')
        AND (@ContactPerson IS NULL OR S.ContactPerson LIKE @ContactPerson + '%')
        AND (@Phone IS NULL OR S.Phone LIKE @Phone + '%')
        AND (@Address IS NULL OR S.[Address] LIKE @Address + '%')

    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'SupplierId'     THEN RIGHT('0000000' + CAST(S.SupplierId AS VARCHAR(10)), 10)
                WHEN 'Name'           THEN S.[Name]
                WHEN 'ContactPerson'  THEN S.ContactPerson
                WHEN 'Phone'          THEN S.Phone
            END
        END ASC,
        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'SupplierId'     THEN RIGHT('0000000' + CAST(S.SupplierId AS VARCHAR(10)), 10)
                WHEN 'Name'           THEN S.[Name]
                WHEN 'ContactPerson'  THEN S.ContactPerson
                WHEN 'Phone'          THEN S.Phone
            END
        END DESC

    OFFSET (@PageNumber - 1) * @PageSize ROWS  
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

EXEC sp_GetSuppliers;
EXEC sp_GetSuppliers 
    @Name = N'ТОВ "Фарм';
EXEC sp_GetSuppliers
    @Phone = N'+38067';
EXEC sp_GetSuppliers
    @Address = N'м. Львів';
EXEC sp_GetSuppliers
    @SortColumn = 'Name',
    @SortDirection = 0;
EXEC sp_GetSuppliers
    @SortColumn = 'ContactPerson',
    @SortDirection = 1;
EXEC sp_GetSuppliers
    @PageSize = 3,
    @PageNumber = 2;





CREATE OR ALTER PROCEDURE dbo.sp_GetClients
    @ClientId INT = NULL,
    @Surname NVARCHAR(100) = NULL,
    @Name NVARCHAR(100) = NULL,
    @Paternal NVARCHAR(100) = NULL,
    @Phone NVARCHAR(20) = NULL,
    @DiscountType NVARCHAR(50) = NULL,
    @HasPrescription BIT = NULL,
    @Address NVARCHAR(200) = NULL,

    @StartDate DATE = NULL,
    @EndDate DATE = NULL,

    @PageSize INT = 20,
    @PageNumber INT = 1,

    @SortColumn VARCHAR(128) = 'ClientId',
    @SortDirection BIT = 0 
AS
BEGIN
    SET NOCOUNT ON;

    IF @ClientId IS NOT NULL
       AND NOT EXISTS(SELECT 1 FROM Clients WHERE ClientId = @ClientId)
    BEGIN
        PRINT 'Incorrect value of @ClientId';
        RETURN;
    END

    SELECT
        C.ClientId,
        C.Surname,
        C.[Name],
        C.Paternal,
        C.BirthDate,
        C.Phone,
        C.HasPrescription,
        C.DiscountType,
        C.[Address],

        COUNT(S.SaleId) AS TotalPurchases,

        SUM(S.TotalAmount) AS TotalSpent,

        CASE 
            WHEN C.DiscountType IS NOT NULL AND C.DiscountType <> N'Немає'
                 AND EXISTS (
                        SELECT 1 
                        FROM Sales S2
                        WHERE S2.ClientId = C.ClientId
                          AND (@StartDate IS NULL OR S2.[Date] >= @StartDate)
                          AND (@EndDate IS NULL OR S2.[Date] <= @EndDate)
                  )
            THEN 1 
            ELSE 0 
        END AS WasDiscountUsed

    FROM Clients C
    LEFT JOIN Sales S
        ON C.ClientId = S.ClientId
        AND (@StartDate IS NULL OR S.[Date] >= @StartDate)
        AND (@EndDate IS NULL OR S.[Date] <= @EndDate)

    WHERE
        (@ClientId IS NULL OR C.ClientId = @ClientId)
        AND (@Surname IS NULL OR C.Surname LIKE @Surname + '%')
        AND (@Name IS NULL OR C.[Name] LIKE @Name + '%')
        AND (@Paternal IS NULL OR C.Paternal LIKE @Paternal + '%')
        AND (@Phone IS NULL OR C.Phone LIKE @Phone + '%')
        AND (@DiscountType IS NULL OR C.DiscountType LIKE @DiscountType + '%')
        AND (@HasPrescription IS NULL OR C.HasPrescription = @HasPrescription)
        AND (@Address IS NULL OR C.[Address] LIKE @Address + '%')

    GROUP BY
        C.ClientId,
        C.Surname,
        C.[Name],
        C.Paternal,
        C.BirthDate,
        C.Phone,
        C.HasPrescription,
        C.DiscountType,
        C.[Address]

    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
            CASE @SortColumn
                WHEN 'ClientId'      THEN RIGHT('0000000' + CAST(C.ClientId AS VARCHAR(10)), 10)
                WHEN 'Surname'       THEN C.Surname
                WHEN 'Name'          THEN C.[Name]
                WHEN 'DiscountType'  THEN C.DiscountType
                WHEN 'HasPrescription' THEN CAST(C.HasPrescription AS VARCHAR(10))
            END
        END ASC,
        CASE WHEN @SortDirection = 1 THEN
            CASE @SortColumn
                WHEN 'ClientId'      THEN RIGHT('0000000' + CAST(C.ClientId AS VARCHAR(10)), 10)
                WHEN 'Surname'       THEN C.Surname
                WHEN 'Name'          THEN C.[Name]
                WHEN 'DiscountType'  THEN C.DiscountType
                WHEN 'HasPrescription' THEN CAST(C.HasPrescription AS VARCHAR(10))
            END
        END DESC

    OFFSET (@PageNumber - 1) * @PageSize ROWS  
    FETCH NEXT @PageSize ROWS ONLY;
END
GO



EXEC sp_GetClients;
EXEC sp_GetClients
    @Surname = N'Ме';
EXEC sp_GetClients
    @Name = N'Ол';
EXEC sp_GetClients
    @Paternal = N'Іва';
EXEC sp_GetClients
    @Phone = N'+38093';
EXEC sp_GetClients
    @DiscountType = N'Студент';
EXEC sp_GetClients
    @HasPrescription = 1;
EXEC sp_GetClients
    @Address = N'м. Харків';
EXEC sp_GetClients
    @SortColumn = 'Surname',
    @SortDirection = 0;
EXEC sp_GetClients
    @SortColumn = 'DiscountType',
    @SortDirection = 1;
EXEC sp_GetClients
    @PageSize = 5,
    @PageNumber = 2;
EXEC sp_GetClients 
    @StartDate = '2025-10-01',
    @EndDate = '2025-10-31';
EXEC sp_GetClients 
    @ClientId = 3,
    @StartDate = '2025-10-01',
    @EndDate = '2025-10-10';
EXEC sp_GetClients 
    @StartDate = '2025-10-01',
    @EndDate = '2025-10-10',
    @DiscountType = '';
