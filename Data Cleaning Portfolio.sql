/*
Cleaning Data in SQL Queries
*/

Select *
from PortfolioProject.dbo.NashvilleHousing

---------Standardize Date Format---------

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


---------Populate Property Address data---------

Select *
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is not null
order by ParcelID


Select a.ParcelID, a.ParcelID, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.ParcelID)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     On a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     On a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



---------Address into Individual Columns---------

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1 )


Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))



Select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing



Select PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
, PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing




Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

Alter table NashvilleHousing
Add OwerSplitState nvarchar(255);

Update NashvilleHousing
SET OwerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


---------Change Y and N to Yes and No in 'SoldAsVacant' field---------

Select Distinct(SoldAsVacant), COunt(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END



---------Remove Duplicates---------

WITH RowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress,
	 SalePrice,SaleDate,LegalReference
	 ORDER BY
	 UniqueID)row_num
From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortfolioProject.dbo.NashvilleHousing



---------Delete Unused Columns---------

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate




