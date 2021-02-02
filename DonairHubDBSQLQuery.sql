
Drop DataBase if Exists WokDonairDB
Create Database  WokDonairDB
GO
USE WokDonairDB

GO
-----Drop Tables if exists
Drop Table if exists Users
Drop Table if Exists Role





----Role table
CREATE TABLE Role
(
	ID int Identity(1,1) Constraint PK_Role Primary Key NOT NULL,
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
	ID INT IDENTITY(1,1) Constraint PK_Users  Primary Key NOT NULL,
	FirstName nvarchar(60) NOT NULL,
	LastName nvarchar(60) NOT NULL,
	Email nvarchar(60) NOT NULL,
	Password text NOT NULL,
	RoleID INT,
	Constraint FK_Role Foreign Key (RoleID) References Role(ID)
)
--ALTER TABLE Users
	--ADD CONSTRAINT PK_Users PRIMARY KEY(ID),
		--CONSTRAINT FK_Role FOREIGN KEY(RoleID) REFERENCES Role(ID)
GO

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
