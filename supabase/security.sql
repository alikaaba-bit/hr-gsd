-- ============================================
-- HR-GSD Security & Auth Setup
-- Run this in Supabase SQL Editor
-- ============================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- STEP 1: Update employees table to use auth.uid()
-- ============================================

-- First, let's see if we need to update the ID column to match auth.users
-- The employees.id should match auth.users.id for proper RLS

-- ============================================
-- STEP 2: Create function to handle new auth users
-- ============================================

-- Function to automatically create employee record when user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if employee record already exists
  IF NOT EXISTS (SELECT 1 FROM public.employees WHERE email = NEW.email) THEN
    -- Create employee record for new auth user
    INSERT INTO public.employees (id, email, name, location, role, active)
    VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
      COALESCE(NEW.raw_user_meta_data->>'location', 'Unknown'),
      COALESCE(NEW.raw_user_meta_data->>'role', 'employee'),
      true
    );
  ELSE
    -- Update existing employee record with auth user ID
    UPDATE public.employees 
    SET id = NEW.id
    WHERE email = NEW.email AND id != NEW.id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to run on new auth user creation
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- STEP 3: Update RLS Policies
-- ============================================

-- Drop existing policies
DROP POLICY IF EXISTS "Allow all read employees" ON employees;
DROP POLICY IF EXISTS "Allow all read reports" ON weekly_reports;
DROP POLICY IF EXISTS "Allow all insert reports" ON weekly_reports;
DROP POLICY IF EXISTS "Allow employees insert own reports" ON weekly_reports;
DROP POLICY IF EXISTS "Allow HR/Admin read all employees" ON employees;
DROP POLICY IF EXISTS "Allow HR/Admin read all reports" ON weekly_reports;

-- Enable RLS
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

-- Employees policies
CREATE POLICY "Employees can view own record" ON employees
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "HR and owners can view all employees" ON employees
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM employees e 
      WHERE e.id = auth.uid() AND e.role IN ('hr', 'owner')
    )
  );

-- Weekly reports policies
CREATE POLICY "Users can view own reports" ON weekly_reports
  FOR SELECT USING (auth.uid() = employee_id);

CREATE POLICY "Users can insert own reports" ON weekly_reports
  FOR INSERT WITH CHECK (auth.uid() = employee_id);

CREATE POLICY "Users can update own reports" ON weekly_reports
  FOR UPDATE USING (auth.uid() = employee_id);

CREATE POLICY "HR and owners can view all reports" ON weekly_reports
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM employees e 
      WHERE e.id = auth.uid() AND e.role IN ('hr', 'owner')
    )
  );

-- ============================================
-- STEP 4: Update existing employee IDs to match auth
-- (Run this after employees sign up)
-- ============================================

-- This matches employees by email to auth users
-- UPDATE public.employees e
-- SET id = u.id
-- FROM auth.users u
-- WHERE e.email = u.email
--   AND e.id != u.id;

-- ============================================
-- STEP 5: Add helpful functions
-- ============================================

-- Function to check if user is HR or owner
CREATE OR REPLACE FUNCTION public.is_hr_or_owner()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.employees 
    WHERE id = auth.uid() 
    AND role IN ('hr', 'owner')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current user's role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
DECLARE
  user_role TEXT;
BEGIN
  SELECT role INTO user_role 
  FROM public.employees 
  WHERE id = auth.uid();
  RETURN user_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'RLS enabled on employees:' as check, 
  (SELECT relrowsecurity FROM pg_class WHERE relname = 'employees') as enabled;

SELECT 'RLS enabled on weekly_reports:' as check,
  (SELECT relrowsecurity FROM pg_class WHERE relname = 'weekly_reports') as enabled;

SELECT 'Active policies on employees:' as info;
SELECT policyname, permissive, roles, cmd FROM pg_policies WHERE tablename = 'employees';

SELECT 'Active policies on weekly_reports:' as info;
SELECT policyname, permissive, roles, cmd FROM pg_policies WHERE tablename = 'weekly_reports';
