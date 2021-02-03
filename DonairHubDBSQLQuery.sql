
Drop DataBase if Exists WokDonairDB
Create Database  WokDonairDB
GO
USE WokDonairDB

GO
-----Drop Tables if exists
Drop Table if exists Users
Drop Table if Exists Role

Drop Table if Exists OrderedItems

Drop Table if Exists Items
Drop Table if Exists Categories


Drop Table if Exists Orders

----Role table
CREATE TABLE Role
(
	ID int Identity(1,1) Primary Key NOT NULL,
	RoleName varchar(16) NOT NULL,
	Description varchar(60) NOT NULL
)
--ALTER TABLE Role
--ADD CONSTRAINT PK_Role PRIMARY KEY(ID)
--drop table Users
GO

---User table
CREATE TABLE Users
(
	ID INT IDENTITY(1,1) Primary Key NOT NULL,
	FirstName nvarchar(60) NOT NULL,
	LastName nvarchar(60) NOT NULL,
	Email nvarchar(60) NOT NULL,
	Password text NOT NULL,
	RoleID INT Foreign Key (RoleID) References Role(ID)
)
--ALTER TABLE Users
	--ADD CONSTRAINT PK_Users PRIMARY KEY(ID),
		--CONSTRAINT FK_Role FOREIGN KEY(RoleID) REFERENCES Role(ID)
GO

--Categories Table
Create Table Categories
(
	ID INT IDENTITY(1,1) Primary Key NOT NULL,
	Name nVarchar(50) NOT NULL,
	Description nVarchar(100) NOT NULL,
	IsDeleted bit  Check(IsDeleted = 'Y' OR IsDeleted = 'N')
	 Default('N')
)

--Items Table
Create Table Items
(
	ID INT IDENTITY(1,1) Primary Key NOT NULL,
	CategoryID INT  Foreign Key(CategoryID) References Categories(ID),
	Name nVarchar(50) NOT NULL,
	Description nVarchar(100) NOT NULL,
	Image Varbinary(Max) null,
	UnitPrice Money not null,
	IsDeleted bit Check(IsDeleted = 'Y' OR IsDeleted = 'N')
	 Default('N')

)


--Orders Table
Create Table Orders
(
	ID INT IDENTITY(1,1)  Primary Key NOT NULL,
	Date nVarchar(30) not null,
	CustomerName nVarchar(50) not null,
	Phone nVarchar(20) not null,
	Email nVarchar(50) null,
	OrderStatus nVarchar(50) not null
)


--OrderedItems Table
Create Table OrderedItems
(
	ID INT IDENTITY(1,1)  Primary Key NOT NULL,
	ItemID INT  Foreign Key(ItemID) References Items(ID),
	OrderID INT  Foreign Key(OrderID) References Orders(ID),
	Quantity INT not null,
	SpecialRequest nVarchar null
)

--drop procedure CreateUser

/*create user */
Drop Procedure If Exists CreateUser
GO
CREATE Procedure CreateUser
(
@FirstName varchar(60) = NULL,
@LastName varchar(60) = NULL,
@Email varchar(60) = NULL,
@Password nvarchar(256) = NULL,
@RoleID int = NULL
)
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	IF @Password IS NULL
		RAISERROR('CreateUser - Required parameter: @Password', 16, 1)
	ELSE
	IF @FirstName IS NULL
		RAISERROR('CreateUser - Required parameter: @FirstName', 16, 1)
	ELSE
	IF @LastName IS NULL
		RAISERROR('CreateUser - Required parameter: @LastName', 16, 1)
	ELSE
	IF @Email IS NULL
		RAISERROR('CreateUser - Required parameter: @Email', 16, 1)
	ELSE
	IF @RoleID IS NULL
		RAISERROR('CreateUser - Required parameter: @RoleID', 16, 1)
	ELSE
		BEGIN
			INSERT INTO Users(FirstName, LastName, Email,Password, RoleID)
			VALUES 
				(@FirstName, @LastName, @Email,@Password, @RoleID)
		IF @@ERROR = 0
					SET @ReturnCode = 0
				ELSE 
					RAISERROR('CreateUser - Add Error from User Table.',16,1)
		END
	RETURN @ReturnCode
GO

/*get user */
Drop Procedure If Exists GetUser
GO
CREATE Procedure GetUser
(
@Email nvarchar(60) = NULL,
@Password nvarchar(256) = NULL
)
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	IF @Password IS NULL
		RAISERROR('GetUser - Required parameter: @Password', 16, 1)
	ELSE
	IF @Email IS NULL
		RAISERROR('GetUser - Required parameter: @Email', 16, 1)
	ELSE
		BEGIN
			SELECT Users.ID,Users.FirstName,Users.LastName,Users.Email,Users.RoleID,Users.Password,
				Role.Description,Role.RoleName,Role.ID
			FROM Users 
				INNER JOIN Role ON Users.RoleID = Role.ID 
				WHERE Email = @Email 
			IF @@ERROR = 0
					SET @ReturnCode = 0
				ELSE 
					RAISERROR('GetUser - Add Error from User Table.',16,1)
		END
	RETURN @ReturnCode
GO

---------Test Data -----------------

insert into Role(Rolename, Description) values ('Admin','Administrator') 
select * from Role

--password: admin123
execute CreateUser 'Keval','Patel','wok.donair@gmail.com','UTQin/QledabGItEv8gA7Q==:G87X5as1EFbJZtA0QbYeZw==',1
---------End Test Data -------------
