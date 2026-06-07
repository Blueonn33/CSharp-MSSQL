SELECT * FROM 
Accounts

BEGIN TRANSACTION
DELETE FROM Accounts Where Id = 6

ALTER TABLE Accounts
ADD IsDeleted BIT 

ROLLBACK

