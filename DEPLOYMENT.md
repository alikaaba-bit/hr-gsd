# Deployment Guide

## Quick Deploy

### 1. Prerequisites
- Node.js 18+
- Railway CLI (optional)
- Git

### 2. Environment Setup

Create `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=https://jrlfcntftckbeqnabtqk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### 3. Local Development
```bash
cd app
npm install
npm run dev
```

### 4. Deploy to Railway

**Option A: CLI**
```bash
cd app
railway login
railway link
railway up
```

**Option B: GitHub Integration**
1. Push to GitHub
2. Connect Railway to GitHub repo
3. Auto-deploy on push

### 5. Supabase Setup

Run these SQL files in Supabase SQL Editor:
1. `/supabase/schema.sql` - Create tables
2. `/supabase/security.sql` - Set up RLS
3. `/supabase/full_employees.sql` - Insert all 56 employees

### 6. Configure Auth (Optional)

In Supabase Dashboard:
- Go to Authentication → Providers → Email
- Toggle "Enable Email provider" ON
- Toggle "Confirm email" OFF (for easier testing)

### 7. Verify Deployment

Check these URLs:
- Landing: https://your-app.railway.app
- Submit: https://your-app.railway.app/submit
- Dashboard: https://your-app.railway.app/dashboard

## Troubleshooting

**Build fails:**
```bash
rm -rf .next
npm run build
```

**Port conflicts:**
```bash
PORT=3001 npm run dev
```

**TypeScript errors:**
Check `src/lib/server.ts` - cookies() is async in Next.js 15+

## Files to Deploy

Required files:
- `/app/**/*`
- `/package.json`
- `/next.config.ts`
- `/tsconfig.json`
- `/.env.local` (environment variables)

## Post-Deploy Checklist

- [ ] Landing page loads with floating emojis
- [ ] Submit form shows "What did you crush this week?"
- [ ] Progress bar starts at 0%
- [ ] Dashboard loads without auth (demo mode)
- [ ] Quote of the Week displays
- [ ] Mobile responsive

## Rollback

If needed, rollback to previous commit:
```bash
git log --oneline
git revert HEAD
railway up
```
