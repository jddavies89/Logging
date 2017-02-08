/* 
Description
	- This script creates the database INVENTORY.mdf and INVENTORYData.ldf files and the table tblDevices with the relevant columns.
Notes
   Author: Joe Richards
   Date:   06/Feb/2017
LINK
  https://github.com/joer89/Logging/Inventory
*/

use master;
go

/* Drop the database if it exists */

if DB_ID('INVENTORY') IS NOT NULL drop database INVENTORY;

/* Create the Inventory Database */

create database INVENTORY on Primary
	(name='INVENTORY',
	filename='C:\INVENTORY\DB\INVENTORY.mdf',
	size=10MB,
	maxsize=Unlimited,
	filegrowth=10%)
log on
	(name='INVENTORY_log',
	filename='C:\INVENTORY\DB\INVENTORYData.ldf',
	size=3MB,
	maxsize=Unlimited,
	filegrowth=10%);
go

/* Create the Table */

use INVENTORY;
go

Create table tblDevices
(
	EntryNumber int identity(1,1) NOT NULL,
	OwnerName varchar(100),
	ComputerName varchar(100),
	SerialNumber varchar(100),
	Make varchar(100),
	Model varchar(100),
	Processor varchar(100),
	DiskModel varchar(100),
	DiskSize varchar(100),
	RAM varchar(100),
	Purchased varchar(100),
	LastUpdated varchar(100)
);
go

/*
Testing
#######

Insert test Data.
insert into tblDevices(OwnerName, ComputerName, SerialNumber, Make, Model, Processor, DiskModel, DiskSize, RAM, Purchased, LastUpdated) values('Joe','sl-10','xxxxxxxx','Lenovo','M73','i3','SanDisk Ultra II 240GB','1024','2948','2014','21-03-2016');
go

Update test Data.
UPDATE tblDevices SET OwnerName='Joe', ComputerName='sl-101', Make='Dell', Model='£6420', Processor='i7', DiskModel='SanDisk Ultra II 240GB', DiskSize='2048', RAM='2048', Purchased='1990', LastUpdated='21-03-2016'   WHERE SerialNumber='xxxxxxxxxxxx';
go

Display the table.
select * from tblDevices
go

*/
