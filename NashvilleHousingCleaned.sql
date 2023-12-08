/*

Data cleaning using SQL Queries

*/

Select * From NashvilleHousing;

-- Standardise date format

Select SaleDate, CONVERT(Date, SaleDate)
From NashvilleHousing;

-- (1) Add new column 
ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

-- (2) Update with correct date format 
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From NashvilleHousing;
-------------------------------------------------------

-- Populate property address data 
Select PropertyAddress
From NashvilleHousing;

Select * From NashvilleHousing
order by ParcelID;

-- Check a.propertyaddress to see if fields are null,if so then populate using b.propertyaddress values 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------

-- Breaking out address from PropertyAddress field into individual columns (Address, City, State)
-- Using Substring

Select PropertyAddress
From NashvilleHousing;


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From NashvilleHousing;

-- Creating two new columns to add the values in  
ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) 

Select *
From NashvilleHousing;

-------------------------------------------------------------------------

-- Breaking out address from OwnerAddress field into individual columns (Address, City, State)
-- Using Parsename

Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address ,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City ,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
From NashvilleHousing;

-- Creating two new columns to add the values in  
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-------------------------------------------------------------------------

-- Change Y and N to Yes and No 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

-------------------------------------------------------------------------

-- Remove duplicate |  Using CTE

WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference 
				 ORDER BY
				 UniqueID 
				 ) row_num
From NashvilleHousing
)
DELETE 
From RowNumCTE
Where row_num > 1


-------------------------------------------------------------------------

--Delete Unused Columns | Not to be done using the raw data given

Select * From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate