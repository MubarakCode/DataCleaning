/*
Cleaning Data to SQL Queries
*/
select * 
from MubarakHousingProjectdb..NashvileHousing
---------------------------------------------------------------
---Standardize Date Format
--the saledate will be converted 
select SaleDateConverted,CONVERT (Date,SaleDate)
from MubarakHousingProjectdb..NashvileHousing
--this will update the date from original date on the table to the convert date 
update NashvileHousing
set SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvileHousing 
Add SaleDateConverted Date;

Update NashvileHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------
--Populate Property Address data
select *
from MubarakHousingProjectdb..NashvileHousing
--where PropertyAddress is null
order by ParcelID
--below will search for parcelID and correspond it with propertyaddress
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)--this line will fill up all the nulls in a.propertyaddress with the data in b.propertyaddress
from MubarakHousingProjectdb..NashvileHousing a
join MubarakHousingProjectdb..NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null --this will display all the null in propertyaddress

update a
Set PropertyAddress = isnull (a.PropertyAddress, b.PropertyAddress)
from MubarakHousingProjectdb..NashvileHousing a
join MubarakHousingProjectdb..NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-------------------------------------------------------
-------Breaking out Address into individual Columns Address City State 

select PropertyAddress
from MubarakHousingProjectdb..NashvileHousing a

select 
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from MubarakHousingProjectdb..NashvileHousing

Alter Table NashvileHousing 
Add PropertySpiltAddress nvarchar(255);

Update NashvileHousing
set PropertySpiltAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) as Address

Alter Table NashvileHousing 
Add PropertySpiltCity nvarchar(255);

Update NashvileHousing
set PropertySpiltCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress)+1, len(PropertyAddress)) as Address

