--Cleaning Date in SQL Queries

Select *
From Projects.dbo.NashvilleHousing



--Standadize date formats
Select SaleDateConverted,CONVERT(Date,SaleDate)
From Projects.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing 
SET SaleDateConverted = CONVERT(Date, SaleDate)





--Populate Property Address Data

Select *
From Projects.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null





-- Breaking out address into individual columns (Address, City, State)

Select PropertyAddress
From Projects.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From Projects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitAddress =SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From Projects.dbo.NashvilleHousing


Select OwnerAddress
From Projects.dbo.NashvilleHousing

-- USING PARSENAME FOR SPLITTING

Select
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From Projects.dbo.NashvilleHousing
--where OwnerAddress is not null

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

Select *
From Projects.dbo.NashvilleHousing

--Chanage Y and N to Yes and No in "Solid and vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
From Projects.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2 

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From Projects.dbo.NashvilleHousing

Update NashvilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



--Remove Duplicates
WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Projects.dbo.NashVilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
where row_num >1
--order by PropertyAddress


From Projects.dbo.NashVilleHousing




--Delete Unused columns
SELECT *
From Projects.dbo.NashvilleHousing

ALTER TABLE Projects.dbo.NashVilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, PropertySplitState

ALTER TABLE Projects.dbo.NashVilleHousing
DROP COLUMN SaleDate


--
