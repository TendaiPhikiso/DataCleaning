# Data Cleaning in SQL | Nashville Housing

This repository contains SQL queries for cleaning and enhancing the Nashville Housing dataset.
The project focuses on standardizing date formats, populating missing values, splitting address fields, changing categorical values, removing duplicates, and dropping unused columns.


![image](https://github.com/TendaiPhikiso/DataCleaning/assets/57633068/c9733d37-d565-467e-826b-1e062c9601e1)
###

# Project Structure
### (1) Date Standardization:
Added a new column, SaleDateConverted, and updated it with the correct date format.

### (2) Populating Property Address Data:
Checked for null values in PropertyAddress and populated them using corresponding values from another row.

### (3) Breaking Out Address from PropertyAddress Field:
Created new columns (PropertySplitAddress and PropertySplitCity) by splitting the PropertyAddress field into individual components (Address, City).

### (4) Breaking Out Address from OwnerAddress Field:
Used PARSENAME and replaced commas with dots to split the OwnerAddress field into individual components (Address, City, State).

### (5) Changing Categorical Values:
Updated the SoldAsVacant column, changing 'Y' to 'Yes' and 'N' to 'No'.

### (6) Removing Duplicates:
Used a Common Table Expression (CTE) to remove duplicate rows based on specific columns.

### (7) Deleting Unused Columns:
Removed unused columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate).
