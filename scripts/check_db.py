#!/usr/bin/env python3
"""
HR-GSD Database Setup Script
Run this to create tables and seed China team data
"""

import os
from supabase import create_client

# Supabase credentials
SUPABASE_URL = "https://jrlfcntftckbeqnabtqk.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpybGZjbnRmdGNrYmVxbmFidHFrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDI4NTQ0ODksImV4cCI6MjA4NTg2MTQ4OX0.Sn5b1X1iV6HI-Spv16NlWwXm1ut0F8w1CP7ClFakFwo"

# Create client with service role key
supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

print("🚀 HR-GSD Database Setup")
print("=" * 50)

# Step 1: Check if tables exist
print("\n1. Checking existing tables...")
try:
    result = supabase.table('employees').select('count', count='exact').execute()
    print(f"   ✓ employees table exists ({result.count} records)")
except Exception as e:
    print(f"   ✗ employees table does not exist (will create)")

# Step 2: Create employees table
print("\n2. Creating employees table...")
try:
    # Try to insert a test record - if it fails, table doesn't exist
    supabase.table('employees').insert({
        'email': 'test@example.com',
        'name': 'Test',
        'location': 'Test',
        'role': 'employee'
    }).execute()
    # Delete test record
    supabase.table('employees').delete().eq('email', 'test@example.com').execute()
    print("   ✓ employees table ready")
except Exception as e:
    print(f"   ✗ Cannot create table via REST API")
    print(f"   Please run SQL manually in Supabase dashboard")
    print(f"   URL: https://supabase.com/dashboard/project/jrlfcntftckbeqnabtqk/sql/new")

# Step 3: Check for existing China team
print("\n3. Checking for China team data...")
try:
    result = supabase.table('employees').select('*').eq('location', 'China').execute()
    if result.data:
        print(f"   ✓ Found {len(result.data)} China employees")
        for emp in result.data[:5]:
            print(f"      - {emp['name']} ({emp['role']})")
    else:
        print("   ✗ No China employees found (need to seed)")
except Exception as e:
    print(f"   ✗ Error checking: {e}")

print("\n" + "=" * 50)
print("📋 Next Steps:")
print("1. If tables don't exist, run SQL in Supabase dashboard")
print("2. If no China data, seed the employees")
print("\nSQL file location: /Users/ali/hr-gsd/supabase/setup.sql")
