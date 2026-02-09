-- HR-GSD Database Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if rebuilding (optional)
-- DROP TABLE IF EXISTS weekly_reports;
-- DROP TABLE IF EXISTS employees;

-- Employees table
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    location TEXT NOT NULL, -- China, Pakistan, USA, etc.
    department TEXT,
    manager_id UUID REFERENCES employees(id),
    role TEXT NOT NULL DEFAULT 'employee', -- employee, hr, admin, owner
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Weekly reports table
CREATE TABLE weekly_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    week_start_date DATE NOT NULL,
    shipped TEXT NOT NULL, -- What did you ship this week?
    blockers TEXT, -- What's blocking you?
    priority_1 TEXT NOT NULL, -- Top priority for next week
    priority_2 TEXT, -- Second priority
    priority_3 TEXT, -- Third priority
    confidence INTEGER NOT NULL CHECK (confidence >= 1 AND confidence <= 10),
    morale INTEGER CHECK (morale >= 1 AND morale <= 5),
    shoutouts TEXT, -- Shoutouts or recognition
    ai_score INTEGER CHECK (ai_score >= 1 AND ai_score <= 10),
    ai_summary TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(employee_id, week_start_date) -- One report per employee per week
);

-- Create indexes for performance
CREATE INDEX idx_weekly_reports_employee_id ON weekly_reports(employee_id);
CREATE INDEX idx_weekly_reports_week_start ON weekly_reports(week_start_date);
CREATE INDEX idx_employees_location ON employees(location);
CREATE INDEX idx_employees_manager_id ON employees(manager_id);
CREATE INDEX idx_employees_role ON employees(role);

-- Enable Row Level Security (RLS)
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Employees: HR and admins can read all
CREATE POLICY "Allow HR/Admin read all employees" ON employees
    FOR SELECT USING (auth.role() = 'authenticated');

-- Weekly Reports: HR/Admin can read all
CREATE POLICY "Allow HR/Admin read all reports" ON weekly_reports
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow employees insert own reports" ON weekly_reports
    FOR INSERT WITH CHECK (auth.uid() = employee_id);

-- ============================================
-- CHINA TEAM - 24 Total (21 Reporters + 3 Owners)
-- ============================================

-- Owners (Excluded from weekly reports)
INSERT INTO employees (email, name, location, department, role) VALUES
('ali@petrabrands.com', 'Ali Kaaba', 'China', 'Top Management', 'owner'),
('rita@petrabrands.com', 'Rita Shi', 'China', 'Top Management', 'owner'),
('mursal@petrabrands.com', 'Mursal Khedri', 'China', 'Top Management', 'owner');

-- HR Manager (Receives reports but doesn't submit)
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

-- Business Management (4)
INSERT INTO employees (email, name, location, department, role) VALUES
('sophie@petrabrands.com', 'Sophie Dong', 'China', 'Business Management', 'employee'),
('chris@petrabrands.com', 'Chris Chen', 'China', 'Business Management', 'employee'),
('jemmy@petrabrands.com', 'Jemmy Yao', 'China', 'Business Management', 'employee'),
('jack@petrabrands.com', 'Jack Yu', 'China', 'Business Management', 'employee'),
('catherine@petrabrands.com', 'Catherine Zhao', 'China', 'Business Management', 'employee');

-- Set manager_id for China team (all report to Rita Shi for now)
UPDATE employees 
SET manager_id = (SELECT id FROM employees WHERE email = 'rita@petrabrands.com')
WHERE location = 'China' AND role = 'employee';

-- Insert Bushra as global HR
INSERT INTO employees (email, name, location, department, role)
VALUES ('bushra@petrabrands.com', 'Bushra Khawaja', 'Pakistan', 'People Management', 'hr')
ON CONFLICT (email) DO UPDATE SET role = 'hr', location = 'Pakistan';
