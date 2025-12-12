-- Усі лікарські форми + список ліків, які до них належать

SELECT rf.ReleaseFormId, rf.Name AS ReleaseForm,
       m.MedicineId, m.Name AS MedicineName, m.Dose
FROM ReleaseForm AS rf
LEFT JOIN Medicine AS m
    ON rf.ReleaseFormId = m.ReleaseFormId
ORDER BY rf.ReleaseFormId;


-- Ліки з інформацією про місце зберігання

SELECT m.MedicineId, m.Name AS MedicineName, ds.Count, s.CellNumber
FROM Medicine AS m
LEFT JOIN DetailsSupply AS ds
    ON m.MedicineId = ds.MedicineId
LEFT JOIN Storage AS s
    ON ds.CellId = s.CellId
ORDER BY m.MedicineId;


-- Поставки з назвами постачальників

SELECT sup.SupplyId, sup.Date, sup.TotalPrice,
       s.Name AS SupplierName, s.Phone
FROM Supply AS sup
JOIN Suppliers AS s
    ON sup.SupplierId = s.SupplierId;


-- Деталі поставок: ліки + їхній постачальник

SELECT ds.DetailsSupplyId, m.Name AS MedicineName, ds.Count, ds.ExpirationDate,
       sup.Date AS SupplyDate, suppliers.Name AS SupplierName
FROM DetailsSupply AS ds
JOIN Medicine AS m
    ON ds.MedicineId = m.MedicineId
JOIN Supply AS sup
    ON ds.SupplyId = sup.SupplyId
JOIN Suppliers AS suppliers
    ON sup.SupplierId = suppliers.SupplierId;


-- Продажі з інформацією про фармацевта та клієнта

SELECT sa.SaleId, sa.Date, sa.TotalAmount,
       ph.Surname + ' ' + ph.Name AS Pharmacist,
       cl.Surname + ' ' + cl.Name AS Client
FROM Sales AS sa
JOIN Pharmacists AS ph
    ON sa.PharmacistId = ph.PharmacistId
LEFT JOIN Clients AS cl
    ON sa.ClientId = cl.ClientId;


-- Список проданих ліків з кількістю та датою продажу

SELECT sa.SaleId, sa.Date, m.Name AS MedicineName,
       sd.MedicineCount, sa.TotalAmount
FROM Sales AS sa
JOIN SaleDetails AS sd
    ON sa.SaleDetailsId = sd.SaleDetailsId
JOIN Medicine AS m
    ON sd.MedicineId = m.MedicineId
ORDER BY sa.Date;


-- Усі постачальники, які не робили поставок

SELECT s.SupplierId, s.Name AS SupplierName, s.Phone
FROM Suppliers AS s
LEFT JOIN Supply AS sup
    ON s.SupplierId = sup.SupplierId
WHERE sup.SupplierId IS NULL;


-- Ліки, які НЕ були поставлені жодного разу

SELECT m.MedicineId, m.Name AS MedicineName, m.Producer
FROM Medicine AS m
LEFT JOIN DetailsSupply AS ds
    ON m.MedicineId = ds.MedicineId
WHERE ds.MedicineId IS NULL;


-- Комірки складу з інформацією про кількість товарів

SELECT st.CellId, st.CellNumber,
       COUNT(ds.DetailsSupplyId) AS ItemsInCell
FROM Storage AS st
LEFT JOIN DetailsSupply AS ds
    ON st.CellId = ds.CellId
GROUP BY st.CellId, st.CellNumber
ORDER BY st.CellNumber;


-- Ліки + форма випуску + інформація про продаж

SELECT m.Name AS MedicineName, rf.Name AS ReleaseForm,
       sd.MedicineCount, sa.Date AS SaleDate
FROM Medicine AS m
JOIN ReleaseForm AS rf
    ON m.ReleaseFormId = rf.ReleaseFormId
JOIN SaleDetails AS sd
    ON m.MedicineId = sd.MedicineId
JOIN Sales AS sa
    ON sd.SaleDetailsId = sa.SaleDetailsId;




SELECT * FROM Sales
WHERE [Date] BETWEEN '2025-10-01' AND '2025-10-06'
SELECT GETDATE(),
EOMONTH(GETDATE()), EOMONTH('2025-10-01'),
DATEFROMPARTS(DATEPART(YEAR, GETDATE()), DATEPART(MONTH, GETDATE()), 1),
DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE())))

DECLARE @StartDay DATE = '2025-10-01',--DATEFROMPARTS(DATEPART(YEAR, GETDATE()), DATEPART(MONTH, GETDATE()), 1),
@EndDay DATE = EOMONTH(GETDATE())
SELECT * FROM Sales
WHERE [Date] BETWEEN @StartDay AND @EndDay

SELECT [Date], SUM(TotalAmount), PharmacistId FROM Sales
WHERE [Date] BETWEEN @StartDay AND @EndDay
GROUP BY [Date], PharmacistId

SELECT SUM(TotalAmount), PharmacistId FROM Sales
WHERE [Date] BETWEEN @StartDay AND @EndDay
GROUP BY PharmacistId
HAVING SUM(TotalAmount) > 200
ORDER BY SUM(TotalAmount) DESC