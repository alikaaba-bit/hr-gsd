-- ============================================
-- HR-GSD Database Setup - China Team
-- Run this in Supabase SQL Editor
-- ============================================

-- Step 1: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 2: Drop existing tables (if rebuilding)
DROP TABLE IF EXISTS weekly_reports;
DROP TABLE IF EXISTS employees;

-- Step 3: Create employees table
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    department TEXT,
    manager_id UUID REFERENCES employees(id),
    role TEXT NOT NULL DEFAULT 'employee',
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 4: Create weekly_reports table
CREATE TABLE weekly_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    week_start_date DATE NOT NULL,
    shipped TEXT NOT NULL,
    blockers TEXT,
    priority_1 TEXT NOT NULL,
    priority_2 TEXT,
    priority_3 TEXT,
    confidence INTEGER NOT NULL CHECK (confidence >= 1 AND confidence <= 10),
    morale INTEGER CHECK (morale >= 1 AND morale <= 5),
    shoutouts TEXT,
    ai_score INTEGER CHECK (ai_score >= 1 AND ai_score <= 10),
    ai_summary TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(employee_id, week_start_date)
);

-- Step 5: Create indexes
CREATE INDEX idx_weekly_reports_employee_id ON weekly_reports(employee_id);
CREATE INDEX idx_weekly_reports_week_start ON weekly_reports(week_start_date);
CREATE INDEX idx_employees_location ON employees(location);
CREATE INDEX idx_employees_role ON employees(role);

-- Step 6: Enable Row Level Security
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

-- Step 7: Create RLS policies
CREATE POLICY "Allow all read employees" ON employees FOR SELECT USING (true);
CREATE POLICY "Allow all read reports" ON weekly_reports FOR SELECT USING (true);
CREATE POLICY "Allow all insert reports" ON weekly_reports FOR INSERT WITH CHECK (true);

-- ============================================
-- CHINA TEAM DATA
-- ============================================

-- Owners (exempt from reports)
INSERT INTO employees (email, name, location, department, role) VALUES
('ali@petrabrands.com', 'Ali Kaaba', 'China', 'Top Management', 'owner'),
('rita@petrabrands.com', 'Rita Shi', 'China', 'Top Management', 'owner'),
('mursal@petrabrands.com', 'Mursal Khedri', 'China', 'Top Management', 'owner');

-- HR (receives reports)
INSERT INTO employees (email, name, location, department, role) VALUES
('morpheus@petrabrands.com', 'Morpheus Qiu', 'China', 'People Management', 'hr');

-- Finance (2)
INSERT INTO employees (email, name, location, department, role) VALUES
('maira@petrabrands.com', 'Maira Mumtaz', 'China', 'Financial Management', 'employee'),
('carey@petrabrands.com', 'Carey Guo', 'China', 'Financial Management', 'employee');

-- Supply Chain Management (10)
INSERT INTO employees (email, name, location, department, role) VALUES
('holly@petrabrands.com', 'Holly Huang', 'China', 'Supply Chain Management', 'employee'),
('elsie@petrabrands.com', 'Elsie Liang', 'China', 'Supply Chain Management', 'employee'),
('ian@petrabrands.com', 'Ian Wang', 'China', 'Supply Chain Management', 'employee'),
('shay@petrabrands.com', 'Shay Wu', 'China', 'Supply Chain Management', 'employee'),
('vanessa@petrabrands.com', 'Vanessa Chen', 'China', 'Supply Chain Management', 'employee'),
('jun@petrabrands.com', 'Jun Mu', 'China', 'Supply Chain Management', 'employee'),
('ming@petrabrands.com', 'Ming Xue', 'China', 'Supply Chain Management', 'employee'),
('linda@petrabrands.com', 'Linda Xie', 'China', 'Supply Chain Management', 'employee'),
('frank@petrabrands.com', 'Frank Pan', 'China', 'Supply Chain Management', 'employee'),
('jim@petrabrands.com', 'Jim Liu', 'China', 'Supply Chain Management', 'employee');

-- Creative Management (3)
INSERT INTO employees (email, name, location, department, role) VALUES
('sheikh@petrabrands.com', 'Sheikh Liu', 'China', 'Creative Management', 'employee'),
('suki@petrabrands.com', 'Suki Su', 'China', 'Creative Management', 'employee'),
('neil@petrabrands.com', 'Neil Zhou', 'China', 'Creative Management', 'employee');

-- Business Management (5)
INSERT INTO employees (email, name, location, department, role) VALUES
('sophie@petrabrands.com', 'Sophie Dong', 'China', 'Business Management', 'employee'),
('chris@petrabrands.com', 'Chris Chen', 'China', 'Business Management', 'employee'),
('jemmy@petrabrands.com', 'Jemmy Yao', 'China', 'Business Management', 'employee'),
('jack@petrabrands.com', 'Jack Yu', 'China', 'Business Management', 'employee'),
('catherine@petrabrands.com', 'Catherine Zhao', 'China', 'Business Management', 'employee');

-- Global HR
INSERT INTO employees (email, name, location, department, role) VALUES
('bushra@petrabrands.com', 'Bushra Khawaja', 'Pakistan', 'People Management', 'hr');

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Employees by role:' as info;
SELECT role, COUNT(*) as count FROM employees GROUP BY role ORDER BY count DESC;

SELECT 'Employees by department:' as info;
SELECT department, COUNT(*) as count FROM employees WHERE role = 'employee' GROUP BY department ORDER BY count DESC;

SELECT 'Total employees:' as info, COUNT(*) as total FROM employees;
SELECT 'Total reporters (excludes owners):' as info, COUNT(*) as total FROM employees WHERE role != 'owner';
