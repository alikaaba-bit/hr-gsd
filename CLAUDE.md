# CLAUDE.md - HR-GSD System

Complete project context for AI assistance.

---

## Project Structure

```
hr-gsd/
├── MEMORY.md                 # Curated long-term memory
├── CLAUDE.md                 # This file - full context
├── memory/
│   ├── 2026-02-07.md         # Daily logs
│   └── projects/             # Feature specs
├── app/                      # Next.js application
│   ├── src/
│   │   ├── app/              # Pages (App Router)
│   │   ├── components/       # Reusable components
│   │   ├── lib/
│   │   │   ├── supabase.ts   # Supabase client
│   │   │   └── ai.ts         # Claude AI integration
│   │   └── types/
│   ├── package.json
│   └── tailwind.config.ts
├── scripts/                  # Utilities
└── docs/                     # Additional docs
```

---

## Architecture

### Frontend (Next.js 14+)
- **App Router** for routing
- **Server Components** for data fetching
- **Client Components** for forms/interactivity
- **Tailwind CSS** for styling

### Backend (Supabase)
- **PostgreSQL** for data
- **Row Level Security (RLS)** for access control
- **Auth** for authentication
- **Realtime** for live dashboard updates

### AI Analysis (Claude API)
- Grades report quality (1-10)
- Flags vague submissions
- Suggests follow-up questions
- Detects patterns (repeated answers)

---

## Database Schema

```sql
-- Employees table
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    timezone TEXT DEFAULT 'UTC',
    team TEXT,
    manager_id UUID REFERENCES employees(id),
    country TEXT,
    role TEXT DEFAULT 'employee', -- 'employee', 'hr', 'admin'
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT now()
);

-- Weekly reports (GSD format)
CREATE TABLE weekly_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id),
    week_start_date DATE NOT NULL,
    submitted_at TIMESTAMP DEFAULT now(),
    
    -- GSD Fields
    shipped TEXT NOT NULL,           -- What did you ship?
    stuck TEXT,                       -- What's blocking you?
    next_priorities JSONB,            -- Top 3 priorities next week
    confidence INTEGER CHECK (confidence >= 1 AND confidence <= 10),
    notes TEXT,                       -- Additional context
    
    -- AI Analysis
    ai_quality_score INTEGER CHECK (ai_quality_score >= 1 AND ai_quality_score <= 10),
    ai_feedback TEXT,
    flagged_for_review BOOLEAN DEFAULT false,
    
    -- Status
    status TEXT DEFAULT 'submitted', -- 'submitted', 'reviewed', 'flagged'
    
    UNIQUE(employee_id, week_start_date)
);

-- Submission tracking for dashboard
CREATE TABLE submission_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    week_start DATE NOT NULL,
    employee_id UUID NOT NULL REFERENCES employees(id),
    submitted BOOLEAN DEFAULT false,
    submitted_at TIMESTAMP,
    days_late INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT now(),
    
    UNIQUE(week_start, employee_id)
);

-- Enable RLS
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE submission_tracking ENABLE ROW LEVEL SECURITY;
```

---

## Environment Variables

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# AI (Claude)
ANTHROPIC_API_KEY=sk-ant-...

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

---

## Key Components

### EmployeeForm
- Weekly submission form
- Auto-saves draft to localStorage
- Validates required fields
- Shows AI feedback after submission

### HRDashboard
- Week selector
- Employee list with submission status
- Filter by team/country/manager
- Export to CSV

### AIAnalyzer
- Analyzes report quality
- Returns score + feedback
- Flags for review if score < 6

---

## GSD Weekly Questions (Template)

Based on https://github.com/glittercowboy/get-shit-done:

1. **What did you ship this week?** (Required, min 50 words)
   - Specific deliverables, outcomes, milestones

2. **What's blocking you?** (Optional)
   - Obstacles, dependencies, needs

3. **Top 3 priorities for next week** (Required)
   - Ranked list of what you'll focus on

4. **Confidence level** (Required, 1-10)
   - How confident are you in hitting next week's goals?

5. **Anything else?** (Optional)
   - Wins, learnings, shoutouts, concerns

---

## AI Grading Criteria

Quality Score (1-10):
- **10**: Exceptional detail, clear outcomes, specific metrics
- **7-9**: Good detail, specific deliverables mentioned
- **5-6**: Adequate but vague in places
- **3-4**: Minimal detail, mostly vague statements
- **1-2**: Unacceptable, missing critical info

Flag for review if:
- Word count < 50 for "shipped"
- Contains vague terms ("worked on stuff", "had meetings")
- Same answer as previous 2+ weeks
- Missing required fields

---

## API Routes

```
/api/reports
  POST   - Submit weekly report
  GET    - Get reports (filtered by user/team/week)

/api/reports/[id]/analyze
  POST   - Trigger AI analysis

/api/dashboard
  GET    - Get dashboard data for HR

/api/employees
  GET    - List employees
  POST   - Add new employee (HR only)

/api/submissions
  GET    - Get submission status for week
```

---

## Deployment Checklist

- [ ] Supabase project created
- [ ] Database migrations applied
- [ ] Auth configured (Google OAuth or email)
- [ ] RLS policies set
- [ ] Vercel project connected
- [ ] Environment variables set
- [ ] AI analysis tested
- [ ] HR dashboard verified

---

## Related Projects

- **Petra Mind** (`/Users/ali/petra-mind/`) - Same context engine pattern
