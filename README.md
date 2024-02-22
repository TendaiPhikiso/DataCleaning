# Data Cleaning in SQL | Nashville Housing

This repository contains SQL queries for cleaning and enhancing the Nashville Housing dataset.
The project focuses on standardizing date formats, populating missing values, splitting address fields, changing categorical values, removing duplicates, and dropping unused columns.


![image](https://github.com/TendaiPhikiso/DataCleaning/assets/57633068/c9733d37-d565-467e-826b-1e062c9601e1)
###

# Project Structure
### (1) Date Standardization:
Added a new column, SaleDateConverted, and updated it with the correct date format.

**SQL Query:**

```sql

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
```

### (2) Populating Property Address Data:
Checked for null values in PropertyAddress and populated them using corresponding values from another row.

**SQL Query:**

```sql
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
```

### (3) Breaking Out Address from PropertyAddress Field:
Created new columns (PropertySplitAddress and PropertySplitCity) by splitting the PropertyAddress field into individual components (Address, City).

**SQL Query:**

```sql
Select PropertyAddress
From NashvilleHousing;

-- Using Substring
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
```

### (4) Breaking Out Address from OwnerAddress Field:
Used PARSENAME and replaced commas with dots to split the OwnerAddress field into individual components (Address, City, State).

**SQL Query:**

```sql
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
```

### (5) Changing Categorical Values:
Updated the SoldAsVacant column, changing 'Y' to 'Yes' and 'N' to 'No'.

**SQL Query:**

```sql
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
```

### (6) Removing Duplicates:
Used a Common Table Expression (CTE) to remove duplicate rows based on specific columns.

**SQL Query:**

```sql
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
```

### (7) Deleting Unused Columns:
Removed unused columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate).

**SQL Query:**

```sql
Select * From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
```
