

/* 
Cleaning the data in SQL Server

*/
select *
from MyPortFolioProject..NashvilleHousing

--Standardize data formate

select SaleDate, CONVERT(DATE,SaleDate) 
from MyPortFolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

-- populate property address data

select PropertyAddress 
from MyPortFolioProject.dbo.NashvilleHousing

SELECT * 
FROM MyPortFolioProject..NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM MyPortFolioProject..NashvilleHousing a
JOIN MyPortFolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM MyPortFolioProject..NashvilleHousing a
JOIN MyPortFolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into indivual column(Address, City, State)


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 3)
from MyPortFolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT * 
FROM MyPortFolioProject..NashvilleHousing

SELECT OwnerAddress
FROM MyPortFolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM MyPortFolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Change Y and N to Yes or No in "Sold as Vagant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM MyPortFolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

SELECT SoldAsVacant
,CASE When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	end
FROM MyPortFolioProject..NashvilleHousing

USE MyPortFolioProject
update NashvilleHousing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	end


	--remove duplicate

	WITH RowNumCTE as (
	select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID) row_num
	FROM MyPortFolioProject..NashvilleHousing
	)
	select *
	FROM RowNumCTE
	where row_num > 1  
	--ORDER BY PropertyAddress


	--delete unused column
	select *
	from MyPortFolioProject..NashvilleHousing

