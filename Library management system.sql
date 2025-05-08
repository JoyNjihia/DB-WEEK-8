
-- Library Management System Database Schema


-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;


-- Table: Authors
-- Stores information about authors

CREATE TABLE IF NOT EXISTS Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    BirthDate DATE,
    Nationality VARCHAR(100)
) ENGINE=InnoDB;


-- Table: Books
-- Stores information about books

CREATE TABLE IF NOT EXISTS Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    PublicationYear INT,
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE SET NULL
) ENGINE=InnoDB;


-- Table: Members
-- Stores information about library members

CREATE TABLE IF NOT EXISTS Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    MembershipDate DATE NOT NULL
) ENGINE=InnoDB;


-- Table: Loans
-- Records the borrowing transactions of books by members

CREATE TABLE IF NOT EXISTS Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    DueDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE
) ENGINE=InnoDB;


-- Table: Reviews
-- Allows members to review books

CREATE TABLE IF NOT EXISTS Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    ReviewDate DATE NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
) ENGINE=InnoDB;


-- Sample Data Insertion


-- Inserting authors
INSERT INTO Authors (FirstName, LastName, BirthDate, Nationality)
VALUES
    ('J.K.', 'Rowling', '1965-07-31', 'British'),
    ('George', 'Orwell', '1903-06-25', 'British'),
    ('Harper', 'Lee', '1926-04-28', 'American');

-- Inserting books
INSERT INTO Books (Title, Genre, PublicationYear, AuthorID)
VALUES
    ('Harry Potter and the Philosopher''s Stone', 'Fantasy', 1997, 1),
    ('1984', 'Dystopian', 1949, 2),
    ('To Kill a Mockingbird', 'Fiction', 1960, 3);

-- Inserting members
INSERT INTO Members (FirstName, LastName, Email, PhoneNumber, MembershipDate)
VALUES
    ('Alice', 'Johnson', 'alice.johnson@example.com', '1234567890', '2025-05-01'),
    ('Bob', 'Smith', 'bob.smith@example.com', '0987654321', '2025-05-02');

-- Inserting loans
INSERT INTO Loans (MemberID, BookID, LoanDate, ReturnDate, DueDate)
VALUES
    (1, 1, '2025-05-03', '2025-05-10', '2025-05-17'),
    (2, 2, '2025-05-04', NULL, '2025-05-11');

-- Inserting reviews
INSERT INTO Reviews (BookID, MemberID, ReviewDate, Rating, ReviewText)
VALUES
    (1, 1, '2025-05-06', 5, 'An enchanting start to a magical series.'),
    (2, 2, '2025-05-07', 4, 'A chilling portrayal of a dystopian future.');

-- Sample Query: Retrieve all books borrowed by a specific member

SELECT
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.ReturnDate
FROM
    Loans l
JOIN
    Members m ON l.MemberID = m.MemberID
JOIN
    Books b ON l.BookID = b.BookID
WHERE
    m.MemberID = 1;


-- Sample Query: Retrieve all reviews for a specific book

SELECT
    r.ReviewDate,
    r.Rating,
    r.ReviewText,
    CONCAT(m.FirstName, ' ', m.LastName) AS Reviewer
FROM
    Reviews r
JOIN
    Members m ON r.MemberID = m.MemberID
WHERE
    r.BookID = 1;

