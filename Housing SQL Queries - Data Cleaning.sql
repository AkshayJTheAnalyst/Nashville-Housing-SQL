/*

Cleaning Data in SQL Queries

*/


SELECT * FROM Nashville_Housing.DBO.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--#Standardize Date Format

Select SaleDate, CONVERT(Date, SaleDate) 
FROM Nashville_Housing.DBO.NashvilleHousing

Update	Nashville_Housing.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate) 


--OR 

ALTER TABLE NashvilleHousing
Add SaleDate2 Date;

Update	Nashville_Housing.dbo.NashvilleHousing
SET SaleDate2= CONVERT(Date, SaleDate) 


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT * 
FROM Nashville_Housing.DBO.NashvilleHousing
where PropertyAddress is Null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing.DBO.NashvilleHousing a
JOIN Nashville_Housing.DBO.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing.DBO.NashvilleHousing a
JOIN Nashville_Housing.DBO.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- Updating Property Adddress 

Select PropertyAddress
From Nashville_Housing.DBO.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Nashville_Housing.DBO.NashvilleHousing


ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
Add PropertySplit_Address01 Nvarchar(255);

Update Nashville_Housing.DBO.NashvilleHousing
SET PropertySplit_Address01 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )



ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
Add PropertySplit_Address02 Nvarchar(255);

Update Nashville_Housing.DBO.NashvilleHousing
SET PropertySplit_Address02 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



-- Updating OwnerAddress Adddress 


Select *
From Nashville_Housing.DBO.NashvilleHousing


Select OwnerAddress
From Nashville_Housing.DBO.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville_Housing.DBO.NashvilleHousing



ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_Housing.DBO.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Nashville_Housing.DBO.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Nashville_Housing.DBO.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Nashville_Housing.DBO.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashville_Housing.DBO.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Nashville_Housing.DBO.NashvilleHousing


Update Nashville_Housing.DBO.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashville_Housing.DBO.NashvilleHousing
Group by SoldAsVacant
order by 2



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville_Housing.DBO.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Nashville_Housing.DBO.NashvilleHousing


ALTER TABLE Nashville_Housing.DBO.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate












