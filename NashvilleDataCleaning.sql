/*

Cleaning Data In SQL Queries

*/
--------------------------------------------------------------------------
Select * from PortfolioProject..NashvilleHousing

--Customize Date

Select SaleDateUpdated, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter table NashvilleHousing
Add SaleDateUpdated Date;

Update NashvilleHousing
Set SaleDateUpdated = Convert(Date,SaleDate)

-------------------------------------------------------------------------

--Populate Property Address Data

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------

--Breaking Down Address into Individual Columns(Address, city,State)

Select PropertyAddress
from NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address


From NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX( ',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

---------------------------------------------------------------------

SELECT OwnerAddress
From NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
From NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)

Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)

Select *
FROM NashvilleHousing

---------------------------------------------------------------------------

-- To RENAME A COLUMN HEADER
--EXEC sp_rename 'NashvilleHousing.OwnerSplitState1' , 'OwnerSplitState'

-----------------------------------------------------------------------------


-- Changing Y and N to Yes and No

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group BY SoldAsVacant
Order By COUNT(SoldAsVacant)

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   End
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   End

Select * from NashvilleHousing


select * from NashvilleHousing

--------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
      ROW_NUMBER() over(
	  Partition By ParcelID,
	               PropertyAddress,
				   SaleDate,
				   SalePrice,
				   LegalReference
				   Order by
				     UniqueID
					 ) row_num
FROM NashvilleHousing
--order by ParcelID
)
Select *
FROM RowNumCTE
Where row_num > 1
--order by PropertyAddress


------------------------------------------------------------------------------


-- Delete Unused Columns

Select *
from NashvilleHousing

Alter Table NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate




