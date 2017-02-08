/* 
Description
	- This script creates the database User_Logins.mdf and User_LoginsData.ldf files and the table tblUser_Logins with the relevant columns.
Notes
   Author: Joe Richards
   Date:   08/Feb/2017
LINK
  https://github.com/joer89/Logging/Log_UserLogins
*/

use master;
go

/* Drop the database if it exists */

if DB_ID('User_Logins') IS NOT NULL drop database User_Logins;

/* Create the User_Logins Database */

create database User_Logins on Primary
	(name='User_Logins',
	filename='C:\User_Logins\SQLDB\User_Logins.mdf',
	size=10MB,
	maxsize=Unlimited,
	filegrowth=10%)
log on
	(name='User_Logins_log',
	filename='C:\User_Logins\SQLDB\User_Logins.ldf',
	size=3MB,
	maxsize=Unlimited,
	filegrowth=10%);
go

/* Create the Table */

use User_Logins;
go

Create table tblUserLogins
(
	EntryNumber int identity(1,1) NOT NULL,
	Username varchar(100),
	ComputerName varchar(100),
	loggedin varchar(100)
);
go

/*
Testing
#######
Insert test Data.
*/
insert into tblUserLogins(Username, ComputerName, loggedin) values('username','PC01','08-02-2017');
go
/*
Display the table.*/
select * from tblUserLogins
go
