
CREATE DATABASE InventoryManagementSystem;
GO

USE InventoryManagementSystem;
GO


CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) UNIQUE NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    SKU NVARCHAR(50) UNIQUE NOT NULL,
    CategoryID INT NULL,
    Quantity INT DEFAULT 0,
    UnitPrice DECIMAL(10, 2),
    Barcode NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    Address NVARCHAR(255),
    CONSTRAINT chk_Phone_Length CHECK (LEN(Phone) BETWEEN 7 AND 15)
);

CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT PRIMARY KEY IDENTITY(1,1),
    SupplierID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) CHECK (UPPER(Status) IN ('PENDING', 'COMPLETED', 'CANCELLED')),
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE PurchaseOrderDetails (
    PODetailID INT PRIMARY KEY IDENTITY(1,1),
    PurchaseOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE SalesOrders (
    SalesOrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100),
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) CHECK (UPPER(Status) IN ('PENDING', 'SHIPPED', 'CANCELLED')),
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

CREATE TABLE SalesOrderDetails (
    SODetailID INT PRIMARY KEY IDENTITY(1,1),
    SalesOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (SalesOrderID) REFERENCES SalesOrders(SalesOrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE StockMovements (
    MovementID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    MovementType NVARCHAR(20) CHECK (MovementType IN ('IN', 'OUT', 'ADJUSTMENT')),
    Quantity INT NOT NULL,
    MovementDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'Manager', 'Staff')),
    CreatedAt DATETIME DEFAULT GETDATE()
);


CREATE TABLE AuditLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Action NVARCHAR(100) NOT NULL,
    TableAffected NVARCHAR(50),
    ActionTime DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Categories (CategoryName, Description) VALUES 
('Electronics', 'Devices and gadgets'),
('Furniture', 'Home and office furniture'),
('Clothing', 'Apparel and accessories'),
('Stationery', 'Office and school supplies');


INSERT INTO Products (Name, SKU, CategoryID, Quantity, UnitPrice, Barcode) VALUES 
('Smartphone', 'ELX001', 1, 100, 499.99, '1234567890123'),
('Laptop', 'ELX002', 1, 50, 899.99, '1234567890124'),
('Table', 'FUR001', 2, 25, 199.99, '1234567890125'),
('Chair', 'FUR002', 2, 50, 49.99, '1234567890126');

INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email, Address) VALUES 
('Al-Farooq Suppliers', 'Ahmed Farooq', '1234567890', 'farooq@suppliers.com', '123 Main St, City'),
('Hassan Traders', 'Hassan Ali', '9876543210', 'hassan@traders.com', '456 Market St, City'),
('Zaid Exports', 'Zaid Khan', '1122334455', 'zaid@exports.com', '789 Industrial Rd, City'),
('Salman Wholesalers', 'Salman Ahmed', '5566778899', 'salman@wholesalers.com', '321 Commerce St, City'),
('Bilal Imports', 'Bilal Sheikh', '6677889900', 'bilal@imports.com', '654 Trade Ave, City');

INSERT INTO Users (Username, PasswordHash, Email, Role) VALUES 
('muhammad', 'rao123', 'muhammad@email.com', 'Admin'),
('ali', 'qwer12', 'ali@email.com', 'Manager'),
('fatima', 'asdf12', 'fatima@email.com', 'Staff'),
('zainab', 'zxcv09', 'zainab@email.com', 'Staff'),
('hamza', 'password123', 'hamza@email.com', 'Manager'),
('yasir', 'mnbv098', 'yasir@email.com', 'Admin');


select* from Users;
INSERT INTO SalesOrders (CustomerName, Status, TotalAmount) VALUES 
('Ayesha Ahmed', 'PENDING', 150.75),
('Umar Khalid', 'SHIPPED', 249.99);

INSERT INTO PurchaseOrders (SupplierID, Status, TotalAmount) VALUES 
(1, 'PENDING', 300.50),
(2, 'COMPLETED', 500.75);

INSERT INTO StockMovements (ProductID, MovementType, Quantity, Description) VALUES 
(1, 'IN', 50, 'Restocked by supplier'),
(2, 'OUT', 10, 'Sold to customer');

INSERT INTO AuditLogs (UserID, Action, TableAffected, Description) VALUES 
(1, 'INSERT', 'Products', 'Added new product Smartphone'),
(2, 'UPDATE', 'Products', 'Updated product quantity for Laptop');

select*from PurchaseOrderDetails;