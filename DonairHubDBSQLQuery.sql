
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
	Description nVarchar(max) NOT NULL,
	IsDeleted bit  Check(IsDeleted = 1 OR IsDeleted = 0)
	 Default(0)
)

--Items Table
Create Table Items
(
	ID INT IDENTITY(1,1) Primary Key NOT NULL,
	CategoryID INT  Foreign Key(CategoryID) References Categories(ID),
	Name nVarchar(50) NOT NULL,
	Description nVarchar(max) NOT NULL,
	Image Varbinary(Max) null,
	UnitPrice Money not null,
	IsDeleted bit  Check(IsDeleted = 1 OR IsDeleted = 0)
	 Default(0)

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


--password: admin123
execute CreateUser 'Keval','Patel','wok.donair@gmail.com','UTQin/QledabGItEv8gA7Q==:G87X5as1EFbJZtA0QbYeZw==',1
---------End Test Data -------------

/*Get Items- Index*/
Drop Procedure If Exists GetAnItems
GO
Drop Procedure If Exists GetAllItems

GO
CREATE Procedure GetAllItems

AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
		BEGIN
			SELECT Items.Name as ItemName, Items.Description as ItemDescription,Items.Image, Items.UnitPrice, Items.IsDeleted, Items.ID as ItemID, Categories.ID as CategoriesID,
			Categories.Name as CategoryName, Categories.Description as CategoryDescription, CategoryID
			FROM Items 
			INNER JOIN Categories ON Categories.ID = Items.CategoryID 
			
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ELSE 
			RAISERROR('GetAnItems - Get Items details error.',16,1)
		END
RETURN @ReturnCode
GO

/*Get Category- Index*/
Drop Procedure If Exists GetAllCategories
GO
CREATE Procedure GetAllCategories

AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
		BEGIN
			SELECT * FROM Categories 
			
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ELSE 
			RAISERROR('GetAllCategories - Get Categories details error.',16,1)
		END
RETURN @ReturnCode
GO

/*create category */
Drop Procedure If Exists AddCategory
GO
CREATE Procedure AddCategory
(
@Name nvarchar(60) = NULL,
@Description nvarchar(max) = NULL
)
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1

	IF @Name IS NULL
		RAISERROR('AddCategory - Required parameter: @Name', 16, 1)
	ELSE
	IF @Description IS NULL
		RAISERROR('AddCategory - Required parameter: @Description', 16, 1)
	ELSE
		BEGIN
			INSERT INTO Categories(Name, Description)
			VALUES 
				(@Name, @Description)
		IF @@ERROR = 0
					SET @ReturnCode = 0
				ELSE 
					RAISERROR('AddCategory - Add Error from Categories Table.',16,1)
		END
	RETURN @ReturnCode
GO

---------Test Data -----------------
exec AddCategory 'Burgers', 'Combination of Buns, Veggies and Souces'
exec AddCategory 'Salads', 'Combination of Veggies and Souces'
exec AddCategory 'Vegetarian', 'Vegetarian Options'
exec AddCategory 'Regular Wok Special Donairs', 'Wok special donairs are cooked with special sauce and sauteed with special vegetables'
exec AddCategory 'Large Wok Special Donairs', 'Wok special donairs are cooked with special sauce and sauteed with special vegetables'
exec AddCategory 'Rice Platters', 'All rice platters are served with donair meat, fresh salad, hummus, pita, and your choice of donair sauce on top'
exec AddCategory 'Kids Specials', 'Special for Kids'
exec AddCategory 'Poutines', 'Combination of fries, cheese curds and Special brown sauce'
exec AddCategory 'Siders', 'Side Dishes'
exec AddCategory 'Beverages', 'Soft Drinks'

Select * from Categories