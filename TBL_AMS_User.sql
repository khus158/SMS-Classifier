Create database AccountManagementSystem
go

use AccountManagementSystem
go

create Schema AMS;
go


CREATE TABLE AMS.[User]
(
  UserID BigInt Identity(1,1) Not Null,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  AccountNo Int Not Null,
  MobileNo Int Not Null,
  CreatedBy Varchar(250) Not Null,
  Created DateTime Not Null,
 )


ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;

--ALTER TABLE AMS.[User]
--ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.AMS_User(UserID);

INSERT INTO AMS.[User](
Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy,Created)
VALUES
('KHUSHI','2004-01-26','2025-04-03','1800.75','987654321','1234567890','KHUSHI'),
('RINKI','2004-01-27','2025-04-03','1700.75','987654892','1234567890','RINKI');

--DELETE FROM AMS.[USER];

--DBCC CHECKDENT ('AMS.[USER]',RESEED,0);

Select * from AMS.[User];
drop table AMS.[User];
 go;






 
CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);


INSERT INTO AMS.[Address]
(
UserID,AddressDetail,CreatedBy,Created
)
VALUES
('2','Bhubaneshwar','KHUSHI'),
('3','Jatni','RINKI');


DELETE FROM AMS.[Address];
DBCC CHECKDENT ('AMS.[Adress]',RESEED,0);

Select * from AMS.[Address];






CREATE TABLE AMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;

INSERT INTO AMS.Account
(
AccountNo,IsSaving,CreatedBy
)
VALUES
('987654321','400','KHUSHI'),
('987654892','600','RINKI');
delete from AMS.Account;

Select * from AMS.Account;
--drop table AMS.Account;






CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

--drop table  AMS.AccountTransaction;


alter table AMS.AccountTransaction alter column AccountID BIGINT NOT NULL

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);


INSERT INTO AMS.AccountTransaction
(
AccountID,Amount,IsDebit,CreatedBy,Created
)
VALUES
('3','1000.56','200','KHUSHI'),
('4','1000.34','500','RINKI');

Select * from AMS.AccountTransaction;







CREATE TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);


ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);


---------------Procedures --------------
create PROCEDURE AMS.Proc_User_Insert
@UserName Nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal (10,6),
@AccountNo int,
@MobileNo int,
@CreatedBy varchar(250)='defaultuser'
as begin
insert into AMS.[USER](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
end



EXEC AMS.Proc_User_Insert 'testing','2025-08-09','2025-07-06',500,123,9876;

Select * from AMS.[USER];











Create PROCEDURE AMS.Proc_UserAndAddress_Insert
@UserName Nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal (10,6),
@AccountNo int,
@MobileNo int,
@AddressDetail nvarchar(max),
@CreatedBy varchar(250)='defaultuser'
as begin

declare @UserID bigint

insert into AMS.[USER](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

set @UserID=scope_identity()
insert into AMS.[Address](UserId,AddressDetail,CreatedBy)
values(@UserID,@AddressDetail,@CreatedBy)
end

EXEC AMS.Proc_UserAndAddress_Insert 'testing','2025-08-09','2025-07-06',500,123,9876,'testuser';

Select * from AMS.[Address];

go








Create PROCEDURE AMS.Proc_UserAccount_Insert
@UserName Nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal (10,6),
@AccountNo int,
@MobileNo int,
@IsSaving bit,
@CreatedBy varchar(250)='defaultuser'
as begin

declare @UserID bigint

insert into AMS.[USER](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

set @UserID=scope_identity()

insert into AMS.[Account](AccountNo,IsSaving,CreatedBy)
values(@AccountNo,@IsSaving,@CreatedBy)
end

EXEC AMS.Proc_UserAccount_Insert 'testing','2025-08-09','2025-07-06',500,123,9876,0;

Select * from AMS.Account;













Create PROCEDURE AMS.Proc_AccountTransaction_Insert
@UserName Nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal (10,6),
@AccountNo int,
@MobileNo int,
@IsSaving bit,
@CreatedBy varchar(250)='defaultuser'
as begin

declare @UserID bigint

insert into AMS.[USER](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

set @UserID=scope_identity()

insert into AMS.[Account](AccountNo,IsSaving,CreatedBy)
values(@AccountNo,@IsSaving,@CreatedBy)
end

EXEC AMS.Proc_UserAccount_Insert 'testing','2025-08-09','2025-07-06',500,123,9876,0;

Select * from AMS.Account;

------------------------------------------------------------------

create procedure AMS.Proc_UserAndAll_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @AddressDetail nvarchar(max),
 @IsSaving bit,
 @Amount decimal(20,2),
 @IsDebit bit,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserID bigint
   declare @AccountID bigint

   insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, AddressDetail, CreatedBy) 
   values (@UserId, @AddressDetail, @CreatedBy)

   INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
   VALUES(@AccountNo, @IsSaving, @CreatedBy)

   set @AccountID = SCOPE_IDENTITY()

   INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
   VALUES(@UserID, @AccountID, @CreatedBy)
   
   INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
   VALUES(@AccountID, @Amount, @IsDebit, @CreatedBy)
end

exec AMS.Proc_UserAndAll_Insert 'khusu', '2003-08-05', '2022-08-23', 8000.0, 16785678, 88264321, 'Goa', 1, 3000.0, 0

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.Account;
SELECT * FROM AMS.UserAccountMapping;
SELECT * FROM AMS.AccountTransaction;


CREATE TABLE AMS.CreditCard
(
  CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
  UserID BIGINT,
  MobileNo VARCHAR(10),
  CardNo VARCHAR(16)
)

insert into AMS.CreditCard values(71, 1111111, 111);
insert into AMS.CreditCard values(1111, 1111111, null);
insert into AMS.CreditCard values(null, 8888, null);

SELECT * FROM AMS.CreditCard;


go

Create table AMS.CreditCardOffer
 (
   CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   CreditCardID BIGINT,
   Offer VARCHAR(MAX)
 )
 
 insert into AMS.CreditCardOffer values (1, 'Offer1')
 insert into AMS.CreditCardOffer values (2, 'Offer2')
 insert into AMS.CreditCardOffer values (Null, 'Offer2')
 SELECT * FROM AMS.CreditCardOffer;




SELECT * FROM AMS.CreditCard cross join AMS.CreditCardOffer---cross join


create table Employee(
EmployeeID BIGINT  NOT NULL PRIMARY KEY,
 ManagerID BIGINT,
 Name VARCHAR(250)
   )
insert into Employee values(1,NULL,'ANKITA')
insert into Employee values(2,1,'RAKESH')
insert into Employee values(3,2,'SURESH')
insert into Employee values(4,2,'NARESH')
SELECT * FROM Employee;
drop table Employee;

Select * from Employee join Employee;
GO
select*  from Employee E , Employee M WHERE
E.ManagerID=M.EmployeeID; 

select*  from Employee E LEFT JOIN Employee M ON
E.ManagerID=M.EmployeeID; 

select*  from Employee E RIGHT JOIN Employee M ON
E.ManagerID=M.EmployeeID; 

select*  from Employee E INNER JOIN Employee M ON
E.ManagerID=M.EmployeeID; 

select emp.EmployeeID,emp.ManagerID,emp.Name EmpName,
case man.Name
when 'RAKESH' then 'R'
when 'SURESH' then 'S'
when 'ANKITA' then 'A'
else 'I AM THE BEST'
END
AS Manager,

IIF(man.Name='ankita','Director','Employee')Designation
 from Employee emp left join Employee man on emp.ManagerID = man.EmployeeID

 Select * from Employee order by name desc,EmployeeID desc;


 drop table Employee

Create table Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  Grade Char(1),
  Salary Decimal(10, 6),
  [Name] VARCHAR(250),
  DOJ DateTime 
)

insert into Employee values (1, 'A', 1000, 'Ankita', getdate())
insert into Employee values (2, 'B', 2000, 'Rakesh', getdate())
insert into Employee values (3, 'C', 3000, 'Naresh', getdate())
insert into Employee values (4, 'A', 3000, 'Suresh', getdate())
insert into Employee values (6, 'B', 5000,  'Mahesh', getdate())
insert into Employee values (7, 'C', 6000,  'Mahesh', getdate())

select grade ,AVG(SALARY) AVG_SALARY from Employee group by Grade

select grade ,MIN(SALARY) AVG_SALARY from Employee group by Grade

select grade ,MAX(SALARY) AVG_SALARY from Employee group by Grade

select grade ,AVG(SALARY) AVG_SALARY, COUNT(*) from Employee group by Grade,salary having AVG(salary)>2000

select * from 
(
  select 1 as id, 2000 as salary, 'B' as grade 
) as x

join
(
  select grade ,AVG(salary) as AVG_SALARY from Employee  group by grade
) as y

on x.grade = y.grade where x.salary > y.AVG_SALARY;









-----------------------------------------------------------------------------------------------

create proc TestMultiInput
@Input varchar(max)
as
begin
end

exec TestMultiInput '111:2222', '123:677', '890:900'

-----sample output
--AcountID AcountNo
--111      2222
--123      677
--890      900

IF OBJECT_ID('tempdb..#tempInput') IS NOT NULL
DROP TABLE #tempInput;

create table #tempInput 
(
  input varchar(200)
)

insert into #tempInput values('111:2222'), ('123:677')

declare @temp varchar(100)
set @temp = (select top 1 input from #tempInput)
while @temp is not null
begin
    print @temp 
	delete from #tempInput where input = @temp
    set @temp = (select top 1 input from #tempInput)
end

DROP TABLE #tempInput;



  
