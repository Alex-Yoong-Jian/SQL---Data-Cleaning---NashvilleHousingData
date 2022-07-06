/*
Cleaning Data in SQL Queries
*/

-- LOOKING AT DATA (ALL)
Select *
FROM dbo.NashvilleHousing;


-- LOOKING AT SALE DATE
SELECT SaleDate
FROM dbo.NashvilleHousing;

-- CREATING NEW COL "SaleDateConverted"
SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);







-- Populating Property Address Data
SELECT *
FROM dbo.NashvilleHousing
ORDER BY ParcelID

-- CHECKING FOR NULL VALUES IN PROPERTY ADDRESS
-- POPULATING FROM THE PARCEL ID > IF PARCEL ID IS SAME IN NEXT ROW AS PREVIOUS, MOST PROBABLY
-- IT WILL BE THE SAME ADDRESS 
-- LOGIC: IF PARCELID SAME AND UID IS NOT SAME

-- SURFACE INVESTIGATION
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- INVESTIGATION EXECUTION 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL





-- BREAKING ADDRESS INTO INDIVIDUAL COL (ADDRESS, CITY, STATE)

-- LOOKING AT ALL PROPERTY ADDRESS
SELECT PropertyAddress
FROM dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
FROM dbo.NashvilleHousing

-- UPDATING TABLE (CREATING A NEW COL)
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 );

-- UPDATING TABLE (CREATING A NEW COL)
ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress));

-- LOOK AT LAST COLS TO DOUBLE CHECK WORK
SELECT * 
FROM dbo.NashvilleHousing






-- CLEANING OWNER ADDRESS FORMAT INTO DIFFERENT COLS
-- FORMAT: ST NAME, CITY, STATE

-- CHECK CURRENT FORMAT
SELECT OwnerAddress
FROM dbo.NashvilleHousing

-- SPLITTING INTO THREE COLS
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM dbo.NashvilleHousing

-- CREATING NEW COL
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

-- CREATING NEW COL
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

-- CREATING NEW COL
ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

-- UPDATING TABLES
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)








-- CHANGING Y AND N TO 'Yes' AND 'No' IN 'Sold As Vacant' COLUMN

-- EDA
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- EDA 
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM dbo.NashvilleHousing

-- UPDATING
UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END





-- REMOVING DUPLICATES

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1






--DELETE UNUSED COLS

SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate