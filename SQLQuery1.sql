-- RaceDay Database Script
CREATE DATABASE RaceDay;
GO
USE RaceDay;
GO

-- Create the Users table
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'Participant',
    date_of_birth DATE,
    gender NVARCHAR(10),
    phone NVARCHAR(20),
    emergency_contact NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- Create the Events table
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200),
    min_age INT DEFAULT 0,
    max_age INT DEFAULT 100,
    gender_category NVARCHAR(20),
    distance_km DECIMAL(5,2) NOT NULL,
    max_participants INT,
    created_at DATETIME DEFAULT GETDATE()
);

-- 4. Create Events Table
CREATE TABLE events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    organizer_id INT NOT NULL FOREIGN KEY REFERENCES users(user_id),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    event_date DATETIME NOT NULL,
    location NVARCHAR(200) NOT NULL,
    entry_fee DECIMAL(10,2) DEFAULT 0,
    max_participants INT,
    status NVARCHAR(20) DEFAULT 'Active',
    category_id INT FOREIGN KEY REFERENCES categories(category_id),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- 5. Create Enrolments Table
CREATE TABLE enrolments (
    enrolment_id INT IDENTITY(1,1) PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES users(user_id),
    event_id INT NOT NULL FOREIGN KEY REFERENCES events(event_id),
    category_id INT FOREIGN KEY REFERENCES categories(category_id),
    enrolment_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) DEFAULT 'Confirmed',
    payment_status NVARCHAR(20) DEFAULT 'Pending',
    amount_paid DECIMAL(10,2) DEFAULT 0,
    bib_number NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Enrolment UNIQUE (participant_id, event_id)
);

-- 6. Create Results Table
CREATE TABLE results (
    result_id INT IDENTITY(1,1) PRIMARY KEY,
    participant_id INT NOT NULL FOREIGN KEY REFERENCES users(user_id),
    event_id INT NOT NULL FOREIGN KEY REFERENCES events(event_id),
    enrolment_id INT NOT NULL FOREIGN KEY REFERENCES enrolments(enrolment_id),
    finish_time TIME,
    position INT,
    rank NVARCHAR(20),
    status NVARCHAR(20) DEFAULT 'Official',
    is_official BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Result UNIQUE (participant_id, event_id)
);

-- 7. Insert Seed Data (2 Organisers, 2 Participants, 3 Events, Categories, Enrolments)
INSERT INTO users (first_name, last_name, email, password_hash, role, date_of_birth) VALUES 
('John', 'Smith', 'organizer1@raceday.com', 'hashedpass123', 'Organizer', '1985-05-20'),
('Jane', 'Doe', 'organizer2@raceday.com', 'hashedpass123', 'Organizer', '1990-08-15'),
('Mike', 'Ross', 'participant1@raceday.com', 'hashedpass123', 'Participant', '1995-01-10'),
('Sarah', 'Connor', 'participant2@raceday.com', 'hashedpass123', 'Participant', '1998-03-25');

INSERT INTO categories (category_name, description, min_age, max_age, gender_category, distance_km, max_participants) VALUES 
('5K Fun Run', 'Beginner friendly short run', 10, 80, 'All', 5.00, 500),
('10K Advanced', 'Intermediate level run', 15, 70, 'All', 10.00, 300),
('Half Marathon', 'Long distance endurance race', 18, 65, 'All', 21.10, 150);

INSERT INTO events (organizer_id, name, description, event_date, location, entry_fee, max_participants, category_id) VALUES 
(1, 'City Spring 5K', 'Annual spring running event', '2026-04-15 08:00:00', 'City Park', 25.00, 500, 1),
(1, 'Midtown 10K', 'Fast paced city run', '2026-05-20 07:00:00', 'Downtown', 40.00, 300, 2),
(2, 'Coastal Half Marathon', 'Scenic coastal route', '2026-06-10 06:30:00', 'Beachfront', 75.00, 150, 3);

INSERT INTO enrolments (participant_id, event_id, category_id, payment_status, amount_paid, bib_number) VALUES 
(3, 1, 1, 'Paid', 25.00, 'A001'),
(4, 1, 1, 'Paid', 25.00, 'A002'),
(3, 2, 2, 'Pending', 0.00, 'B001');

INSERT INTO results (participant_id, event_id, enrolment_id, finish_time, position) VALUES 
(3, 1, 1, '00:25:30', 1),
(4, 1, 2, '00:27:10', 2);
