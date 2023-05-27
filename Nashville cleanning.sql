
--cleaning data in sql queries

select*
from ProjectPortfolio.dbo.NashvilleCleaning

--standardized date format

select saledateConverted, convert(date, saledate)
from ProjectPortfolio.dbo.NashvilleCleaning

update NashvilleCleaning
set saledate = convert(date, saledate)

alter table nashvillecleaning
add SaleDateConverted Date;

update NashvilleCleaning
set SaleDateConverted = convert(date, saledate)



--Populating Property address

select *
from ProjectPortfolio.dbo.NashvilleCleaning
--where propertyaddress is null
order by parcelid



select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress )
from ProjectPortfolio.dbo.NashvilleCleaning a
join ProjectPortfolio.dbo.NashvilleCleaning b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


update a
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress )
from ProjectPortfolio.dbo.NashvilleCleaning a
join ProjectPortfolio.dbo.NashvilleCleaning b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


--Breaking out address into individual column (address, city, state)

select propertyaddress
from ProjectPortfolio.dbo.NashvilleCleaning
--where propertyaddress is null
--order by parcelid

select
substring(propertyaddress, 1, CHARINDEX(',',  propertyaddress)-1) as Address
, substring(propertyaddress, CHARINDEX(',',  propertyaddress) +1, LEN(PROPERTYADDRESS)) as Address
from ProjectPortfolio.dbo.NashvilleCleaning


alter table nashvillecleaning
add Propertysplitaddress nvarchar(255);

update NashvilleCleaning
set Propertysplitaddress = substring(propertyaddress, 1, CHARINDEX(',',  propertyaddress)-1)


alter table nashvillecleaning
add PropertySplitcity nvarchar(255);

update NashvilleCleaning
set PropertySplitcity = substring(propertyaddress, CHARINDEX(',',  propertyaddress) +1, LEN(PROPERTYADDRESS))


select*
from ProjectPortfolio.dbo.NashvilleCleaning



select owneraddress
from ProjectPortfolio.dbo.NashvilleCleaning

select 
PARSENAME(replace(owneraddress, ',', '.'), 3)
,PARSENAME(replace(owneraddress, ',', '.'), 2)
,PARSENAME(replace(owneraddress, ',', '.'), 1)
from ProjectPortfolio.dbo.NashvilleCleaning






alter table nashvillecleaning
add Ownersplitaddress nvarchar(255);

update NashvilleCleaning
set Ownersplitaddress = PARSENAME(replace(owneraddress, ',', '.'), 3)


alter table nashvillecleaning
add OwnerSplitcity nvarchar(255);

update NashvilleCleaning
set OwnerSplitcity = PARSENAME(replace(owneraddress, ',', '.'), 2)

alter table nashvillecleaning
add Ownersplitstate nvarchar(255);

update NashvilleCleaning
set Ownersplitstate = PARSENAME(replace(owneraddress, ',', '.'), 1)


select*
from ProjectPortfolio.dbo.NashvilleCleaning



--change Y AND N yes to no in "sold as vacant" field

select distinct(soldasvacant), count(soldasvacant)
from ProjectPortfolio.dbo.NashvilleCleaning
group by soldasvacant
order by 2


select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
   when soldasvacant = 'N' then 'NO'
   Else soldasvacant
   END
from ProjectPortfolio.dbo.NashvilleCleaning



update NashvilleCleaning
set soldasvacant =  case when soldasvacant = 'Y' then 'Yes'
   when soldasvacant = 'N' then 'NO'
   Else soldasvacant
   END


   --remove duplicate


with rownumCTE AS(
select*,
 ROW_NUMBER() OVER (
 PARTITION by parcelid, 
			Propertyaddress,
			saleprice,
			saledate,
			legalreference
			order by 
			uniqueid
			) row_num

from ProjectPortfolio.dbo.NashvilleCleaning
--order by ParcelID
)
SELECT*
from rownumCTE
Where row_num > 1
order by PropertyAddress



--Delete unsed columns

select*
from ProjectPortfolio.dbo.NashvilleCleaning

  
  alter table ProjectPortfolio.dbo.NashvilleCleaning
  drop column owneraddress, taxdistrict, propertyaddress

    alter table ProjectPortfolio.dbo.NashvilleCleaning
  drop column saledate