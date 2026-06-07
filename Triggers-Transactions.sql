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