# MEMORY.md - HR-GSD System

Long-term memory for the HR Get-Shit-Done tracking system.

---

## Project Overview

**Name:** HR-GSD  
**Purpose:** Weekly employee reporting system for distributed teams (China, Canada, Pakistan, US)  
**Based on:** https://github.com/glittercowboy/get-shit-done workflow  
**Location:** `/Users/ali/hr-gsd/`

---

## Tech Stack (Decided)

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Frontend | Next.js + Tailwind | Familiar, fast, easy auth |
| Backend/DB | Supabase | Multi-region, auth built-in, realtime |
| AI Analysis | Kimi K2.5 (Moonshot) | Quality grading, flagging low-effort reports |
| Hosting | Vercel | Global CDN, good for China/Canada/Pakistan/US |

---

## Core Features

1. **Employee Form** — Weekly GSD-based submission
2. **HR Dashboard** — View submissions, filter, track missing reports
3. **AI Analyzer** — Score report quality, flag vague submissions
4. **Quarterly Rollup** — Aggregate weekly data for assessments

---

## Data Model

### employees
- id, name, email, timezone, team, manager_id, country, active, created_at

### weekly_reports
- id, employee_id, week_start_date, submitted_at, status
- shipped (text), stuck (text), next_priorities (json), confidence (int)
- ai_quality_score, ai_feedback, flagged_for_review

### submission_tracking
- week_start, employee_id, submitted, submitted_at, days_late

---

## Decisions Log

| Date | Decision | Context |
|------|----------|---------|
| 2026-02-07 | Context engine pattern | Same as Petra Mind for continuity |
| 2026-02-07 | Supabase chosen | Database + Auth + Realtime in one |
| 2026-02-07 | Kimi K2.5 for AI | Ali's preferred model |
| 2026-02-07 | Email auth | Preferred over Google OAuth |

---

## Open Questions

- [ ] Exact weekly questions (waiting on Ali)
- [ ] Auth method: Google OAuth vs email/password
- [ ] Notification preferences (Slack? Email?)
- [ ] PII/data residency requirements

---

## Quick Commands

```bash
# Start dev server
cd /Users/ali/hr-gsd/app && npm run dev

# Supabase local (if needed)
supabase start
```
