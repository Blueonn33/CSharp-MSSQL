CREATE DATABASE LibraryDB_ExamPrep
USE LibraryDB_ExamPrep

---------------------------------
-- SECTION 1

-- 01
CREATE TABLE Genres
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	[Name] NVARCHAR(30) NOT NULL,
);

CREATE TABLE Contacts
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Email NVARCHAR(100),
	PhoneNumber NVARCHAR(20),
	PostAddress NVARCHAR(200),
	Website NVARCHAR(50)
);

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	[Name] NVARCHAR(100) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Libraries
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	[Name] NVARCHAR(50) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Title NVARCHAR(100) NOT NULL,
	YearPublished INT NOT NULL,
	ISBN NVARCHAR(13) UNIQUE NOT NULL,
	AuthorId INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL
)

CREATE TABLE LibrariesBooks
(
	LibraryId INT FOREIGN KEY REFERENCES Libraries(Id),
	BookId INT FOREIGN KEY REFERENCES Books(Id),
	PRIMARY KEY(LibraryId, BookId),
)

-----------------------------------
-- SECTION 2

-- INSERT

INSERT INTO Contacts (Email, PhoneNumber, PostAddress, Website)
VALUES
(NULL, NULL, NULL, NULL),
(NULL, NULL, NULL, NULL),
('stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
('suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com');

INSERT INTO Authors ([Name], ContactId)
VALUES
('George Orwell', 21),
('Aldous Huxley', 22),
('Stephen King', 23),
('Suzanne Collins', 24);

INSERT INTO Books (Title, YearPublished, ISBN, AuthorId, GenreId)
VALUES
('1984', 1949, '9780451524935', 16, 2),
('Animal Farm', 1945, '9780451526342', 16, 2),
('Brave New World', 1932, '9780060850524', 17, 2),
('The Doors of Perception', 1954, '9780060850531', 17, 2),
('The Shining', 1977, '9780307743657', 18, 9),
('It', 1986, '9781501142970', 18, 9),
('The Hunger Games', 2008, '9780439023481', 19, 7),
('Catching Fire', 2009, '9780439023498', 19, 7),
('Mockingjay', 2010, '9780439023511', 19, 7);

INSERT INTO LibrariesBooks (LibraryId, BookId)
VALUES
(1, 36),
(1, 37),
(2, 38),
(2, 39),
(3, 40),
(3, 41),
(4, 42),
(5, 44);

-- UPDATE

UPDATE c
SET Website = CONCAT('www.', LOWER(REPLACE([Name], ' ', '')), '.com')
FROM Contacts AS c
JOIN Authors AS a ON a.ContactId = c.Id
WHERE Website IS NULL

-- DELETE

DELETE 
	FROM LibrariesBooks
WHERE BookId IN 
(
	SELECT b.Id 
	FROM Books b
	JOIN Authors a ON b.AuthorId = a.Id
	WHERE a.[Name] = 'Alex Michaelides'
)

DELETE
FROM Books
WHERE AuthorId IN 
(
	SELECT Id
	FROM Authors
	WHERE [Name] = 'Alex Michaelides'
)

DELETE 
FROM Authors
WHERE [Name] = 'Alex Michaelides'

---------------------------------
-- SECTION 3 --

-- 05
SELECT 
		Title AS [Book Title],
		ISBN,
		YearPublished AS YearReleased
FROM Books
ORDER BY YearPublished DESC, Title ASC

-- 06
SELECT 
		b.Id,
		b.Title,
		b.ISBN,
		g.[Name]
FROM Books b
JOIN Genres g ON b.GenreId = g.Id
WHERE g.[Name] IN ('Historical Fiction', 'Biography')
ORDER BY g.[Name], b.Title

-- 07
WITH MysteryBooksLibraryIdsCte
AS
(
	SELECT l.Id
	FROM Libraries AS l
	JOIN LibrariesBooks AS lb ON lb.LibraryId = l.Id
	JOIN Books AS b ON lb.BookId = b.Id
	JOIN Genres AS g ON b.GenreId = g.Id
	WHERE g.[Name] = 'Mystery'     
)

SELECT 
		l.[Name] AS [Library],
		c.Email
FROM Libraries l
JOIN Contacts c ON l.ContactId = c.Id
WHERE l.Id NOT IN 
(
	SELECT Id
	FROM MysteryBooksLibraryIdsCte
)
ORDER BY l.[Name] ASC