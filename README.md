# HR-GSD | Petra Pulse

**Weekly Reporting System for Distributed Teams**

🔗 **Live URL:** https://hr-gsd-production.up.railway.app

## 🎯 Project Overview

HR-GSD (Get Stuff Done) is a gamified weekly reporting system built for Petra Brands' distributed team across 6 countries (China, Pakistan, USA, Canada, Philippines, Poland).

### What It Does
- **Employees** submit fun, engaging weekly reports
- **HR/Owners** view dashboard with team metrics
- **AI Analysis** provides quality scores and feedback
- **Quote of the Week** rotates through 8 themes (Sustainability, Wellness, Innovation, etc.)

## 🚀 Quick Links

- **Landing:** https://hr-gsd-production.up.railway.app
- **Submit Report:** https://hr-gsd-production.up.railway.app/submit
- **HR Dashboard:** https://hr-gsd-production.up.railway.app/dashboard

## 🛠️ Tech Stack

- **Frontend:** Next.js 16 + TypeScript + Tailwind CSS
- **Backend:** Supabase (PostgreSQL + Auth)
- **AI:** Claude API for report analysis
- **Animations:** Framer Motion
- **Hosting:** Railway
- **Icons:** Lucide React

## ✨ Key Features

### For Employees
- 🎉 Fun, non-corporate UI with floating emojis
- 💪 "What did you crush this week?" (not "ship")
- 😊 Emoji morale selector (😞 😐 🙂 😊 😄)
- 📊 Progress bar that fills as you type
- 🎊 Celebration animation on submit
- 🏆 Achievement system (streaks, badges)

### For HR
- 📊 Dashboard with team metrics
- 📈 Average morale & confidence tracking
- 🚧 Common blockers identification
- ✅ Submission status (on-time/late/missing)
- 🌟 AI-generated highlights

### Security
- Role-based access (employee/hr/owner)
- Row Level Security (RLS) on all tables
- Auth via Supabase (currently disabled for demo)

## 📋 Database Schema

### Tables
- `employees` - 56 team members across 6 countries
- `weekly_reports` - Submitted reports with AI scores

### Roles
- **owner** (3) - Ali, Rita, Mursal - exempt from reports
- **hr** (2) - Morpheus, Bushra - receive reports
- **employee** (51) - submit weekly reports

## 🎨 Design System

- **Colors:** Indigo primary (#6366f1), slate grays
- **Typography:** Geist font family
- **Radius:** 12px rounded corners
- **Animations:** 300ms ease transitions
- **Mobile-first:** Responsive design

## 🚀 Deployment

### Environment Variables
```env
NEXT_PUBLIC_SUPABASE_URL=https://jrlfcntftckbeqnabtqk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Deploy to Railway
```bash
cd app
railway login
railway link
railway up
```

## 📁 Project Structure

```
hr-gsd/
├── app/                    # Next.js app router
│   ├── page.tsx           # Landing page
│   ├── submit/page.tsx    # Report form
│   ├── dashboard/page.tsx # HR dashboard
│   └── login/page.tsx     # Auth (disabled)
├── components/
│   ├── ui/                # UI components
│   ├── QuoteOfTheWeek.tsx
│   └── CelebrationOverlay.tsx
├── lib/
│   ├── supabase.ts        # Database client
│   └── server.ts          # Server utilities
├── supabase/
│   ├── schema.sql         # Database schema
│   └── security.sql       # RLS policies
└── PROJECT_GSD.md         # Project tracking
```

## 📝 GSD Workflow

This project follows the GSD (Get Stuff Done) methodology:

1. **Ship** - Clear deliverables/outcomes
2. **Blockers** - Surface obstacles early
3. **Next Up** - Top 3 priorities only
4. **Confidence** - Honest 1-10 rating

See `PROJECT_GSD.md` for full project history.

## 🎉 Credits

- **Built with:** Claude AI + OpenClaw
- **Inspired by:** https://github.com/glittercowboy/get-shit-done
- **Team:** Petra Brands (56 employees, 6 countries)

---

**Status:** ✅ Live in Production  
**Last Updated:** Feb 9, 2026
