SELECT * FROM 
Accounts

BEGIN TRANSACTION
DELETE FROM Accounts Where Id = 6

ALTER TABLE Accounts
ADD IsDeleted BIT 

ROLLBACK

GO

CREATE OR ALTER TRIGGER tr_AccountSoftDelete
ON Accounts
INSTEAD OF DELETE 
AS
UPDATE Accounts 
SET IsDeleted = 1
WHERE Id IN (SELECT Id FROM deleted)

GO

-- 01
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY (1, 1),
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum DECIMAL NOT NULL,
	NewSum DECIMAL NOT NULL
)

INSERT INTO Logs (AccountId, OldSum, NewSum)
VALUES (2, 123.12, 113.12)

SELECT * FROM Logs
SELECT * FROM Accounts

ALTER TABLE Logs
ALTER COLUMN NewSum DECIMAL(10,2)

GO

CREATE OR ALTER TRIGGER tr_LogChanges
ON Accounts
AFTER UPDATE
AS
BEGIN
		INSERT INTO Logs (AccountId, OldSum, NewSum)
		SELECT i.Id, d.Balance, i.Balance
		FROM inserted i
		JOIN deleted d ON d.Id = i.Id
		WHERE d.Balance != i.Balance
END

UPDATE Accounts
SET Balance += 17.17
WHERE Id = 1

GO

-- 02
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
	[Subject] VARCHAR(50) NOT NULL,
	[Body] VARCHAR(200) NOT NULL
);

GO

CREATE OR ALTER TRIGGER tr_NotificationEmail
ON Logs
AFTER INSERT
AS
BEGIN
		INSERT INTO NotificationEmails (Recipient, [Subject], [Body])
		SELECT i.AccountId, 
			   'Balance change for account: ' + CAST(i.AccountId AS varchar(10)),
			   'On ' + CONVERT(varchar(30), GETDATE()) +
				' your balance was changed from ' + 
				CAST(i.OldSum AS varchar(20)) + 
				' to ' + 
				CAST(i.NewSum AS varchar(20)) + '.'
		FROM inserted i
END

GO

-- 03
GO

CREATE PROCEDURE usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(18,4)) AS
BEGIN
		IF (@moneyAmount >= 0)
		BEGIN
			UPDATE Accounts
			SET Balance += @moneyAmount
			WHERE Id = @accountId
		END
END

GO

-- 04
GO

CREATE PROCEDURE usp_WithdrawMoney (@accountId INT, @moneyAmount DECIMAL(18,4)) AS
BEGIN
		IF (@moneyAmount >= 0)
		BEGIN
			UPDATE Accounts
			SET Balance -= @moneyAmount
			WHERE Id = @accountId
		END
END

GO

-- 05
GO

CREATE PROCEDURE usp_TransferMoney(@senderId INT, @receiverId INT, @amount DECIMAL(18,4)) AS
BEGIN
		IF (@amount > 0)
		BEGIN
			EXEC dbo.usp_DepositMoney @receiverId, @amount
			EXEC dbo.usp_WithdrawMoney @senderId, @amount
		END	
END

GO

-- 06
GO

CREATE OR ALTER TRIGGER tr_UserIsBelowMinLevel
ON UserGameItems
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Items it ON it.Id = i.ItemId
        JOIN UsersGames ug ON ug.Id = i.UserGameId
        WHERE it.MinLevel > ug.Level
    )
    BEGIN
        THROW 50001, 'You cannot buy an item above your level.', 1;
    END
END

GO

GO

UPDATE ug
SET ug.Cash += 50000
FROM UsersGames ug
JOIN Users u ON ug.UserId = u.Id
JOIN Games g ON ug.GameId = g.Id
WHERE u.Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
  AND g.Name = 'Bali';

GO

INSERT INTO UserGameItems (ItemId, UserGameId)
SELECT it.Id, ug.Id
FROM Items it
CROSS JOIN UsersGames ug
JOIN Users u ON ug.UserId = u.Id
JOIN Games g ON ug.GameId = g.Id
WHERE u.Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
  AND g.Name = 'Bali'
  AND (
        it.Id BETWEEN 251 AND 299
        OR it.Id BETWEEN 501 AND 539
      );
