select * from house.dbo.housing

-- Standardize Date Format
select SaleDate , Convert(Date,SaleDate) as saledateconverted
from housing

update housing
set SaleDate=Convert(Date,SaleDate)

-- Poplate Property Address Data

select *
from housing
--where PropertyAddress is null
order by parcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from housing a
join housing b
on a.ParcelID= b.parcelID
and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from housing a
join housing b
on a.ParcelID= b.parcelID
and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out address into individual columnes (address, city, state)

select propertyaddress 
from housing

select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as address
, SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as address

from housing

ALTER TABLE housing
Add PropertySplitAddress Nvarchar(255);

Update housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing
Add PropertySplitCity Nvarchar(255);

Update housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from housing

-- change y and n to yes and no in "sold as vacant" field

select distinct(soldasvacant), count(SoldAsVacant)
from housing
group by SoldAsVacant
order by 2

select soldasvacant
,case when soldasvacant ='Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else SoldAsVacant
	end
from housing

update housing 
set soldasvacant = case when soldasvacant ='Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else SoldAsVacant
	end

select soldasvacant 
from housing

-- remove duplicates

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

From housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From housing


-- delete unused columns

Select *
From housing


ALTER TABLE housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
