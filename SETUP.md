# HR-GSD Setup Instructions

Complete setup guide for the HR-GSD weekly reporting system.

## Prerequisites

- Node.js 18+ installed
- npm or yarn
- A Supabase account (free tier works)
- (Optional) Claude API key or Moonshot API key for AI analysis
- (Optional) Resend account for email sending

## Step 1: Install Dependencies

```bash
cd /Users/ali/hr-gsd/app
npm install
```

## Step 2: Set Up Supabase

### Create a Project

1. Go to https://supabase.com and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - Name: `hr-gsd`
   - Database Password: (generate a strong password)
   - Region: Choose closest to your team (e.g., Singapore for China team)
5. Click "Create New Project"
6. Wait for the database to be provisioned (1-2 minutes)

### Run the Schema

1. In your Supabase project, go to the **SQL Editor** (left sidebar)
2. Click "New Query"
3. Copy the entire contents of `/supabase/schema.sql`
4. Paste into the SQL Editor
5. Click "Run"

This will:
- Create the `employees` and `weekly_reports` tables
- Set up indexes for performance
- Enable Row Level Security
- Insert 24 China employees as seed data

### Get Your API Keys

1. Go to **Project Settings** → **API** (in the left sidebar)
2. Copy these values:
   - **Project URL**: `https://xxxxxx.supabase.co`
   - **anon/public key**: `eyJ...`
   - **service_role key**: (only if you need admin operations)

## Step 3: Configure Environment Variables

1. Copy the example file:
   ```bash
   cp .env.local.example .env.local
   ```

2. Edit `.env.local` with your credentials:
   ```env
   # Supabase (required)
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

   # AI Analysis (pick one)
   CLAUDE_API_KEY=your-claude-api-key
   # or
   MOONSHOT_API_KEY=your-moonshot-api-key

   # Email (optional)
   RESEND_API_KEY=your-resend-api-key
   ```

### Getting API Keys

**Claude API:**
1. Go to https://console.anthropic.com
2. Create an account
3. Generate an API key
4. (Note: Claude API requires approval, may take 24-48 hours)

**Moonshot API (fallback):**
1. Go to https://platform.moonshot.cn
2. Sign up and create an API key
3. This works immediately and is cheaper for Chinese users

**Resend (for emails):**
1. Go to https://resend.com
2. Sign up with your domain
3. Verify your domain (petrabrands.com)
4. Generate an API key

## Step 4: Run the App

```bash
npm run dev
```

The app will be available at http://localhost:3000

## Step 5: Test the Setup

1. Open http://localhost:3000
2. Click "Submit Weekly Report"
3. Fill out the form (note: auto-save will save to localStorage)
4. Submit the report
5. Check the Dashboard to see your report

## Step 6: Set Up Weekly Email (Optional)

### Option A: Vercel Cron (Recommended for Vercel hosting)

1. Create `vercel.json` in the app root:
   ```json
   {
     "crons": [
       {
         "path": "/api/weekly-summary",
         "schedule": "30 17 * * 5"
       }
     ]
   }
   ```

2. Deploy to Vercel

### Option B: External Cron Service

Use a service like:
- **Cron-job.org** (free)
- **EasyCron** (free tier available)
- **AWS EventBridge** (if using AWS)

Set up to call:
```
GET https://your-app.com/api/weekly-summary
```
Every Friday at 17:30 (5:30pm)

### Option C: Server Cron (Self-hosted)

Add to crontab:
```bash
# Edit crontab
crontab -e

# Add this line for Friday 5:30pm
30 17 * * 5 curl -s https://your-app.com/api/weekly-summary > /dev/null 2>&1
```

Or use the provided script:
```bash
# Run manually
./scripts/weekly-summary.sh

# Run for specific week
./scripts/weekly-summary.sh 2026-02-03
```

## Step 7: Deploy to Production

### Vercel (Easiest)

1. Push code to GitHub
2. Go to https://vercel.com
3. Import your repository
4. Add environment variables in Vercel dashboard
5. Deploy

### Other Platforms

Build the app:
```bash
cd app
npm run build
```

Then serve the `dist` folder with any static file server.

## Configuration

### Customizing Employee List

Edit `/supabase/schema.sql` and modify the INSERT statements:

```sql
INSERT INTO employees (email, name, location, department, role) VALUES
('new.employee@petrabrands.com', 'New Employee', 'Pakistan', 'Engineering', 'employee'),
-- ... more employees
```

Then re-run the SQL in Supabase.

### Customizing Email Recipients

Edit `/app/src/app/api/weekly-summary/route.ts`:

```typescript
recipients: [
  'morpheus@petrabrands.com',
  'bushra@petrabrands.com',
  'you@petrabrands.com'  // Add more here
]
```

### Changing the Friday Deadline

Edit `/app/src/lib/supabase.ts`:

```typescript
// In isReportLate function
fridayDeadline.setHours(17, 30, 0, 0)  // Change 17 (5pm) and 30 (minutes)
```

## Troubleshooting

### "Failed to fetch" / Network errors
- Check Supabase URL is correct
- Verify anon key is correct
- Check browser console for CORS errors

### "relation does not exist" errors
- Schema hasn't been run in Supabase
- Go to SQL Editor and run schema.sql again

### AI analysis not working
- Check API key is set correctly
- Check browser console for errors
- The app will fall back to basic scoring if AI fails

### Emails not sending
- Check RESEND_API_KEY is set
- Verify domain is verified in Resend
- Check server logs - email content is always logged

### Reports not showing in dashboard
- Check week selector is set to correct date
- Verify employee_id in reports matches employees table
- Check for JavaScript errors in browser console

## Next Steps

1. Add authentication (Supabase Auth)
2. Add role-based access control
3. Add report editing for HR
4. Add export to CSV/PDF
5. Add trend charts and analytics

## Support

For issues or questions:
- Check README.md for overview
- Review code comments
- Check Supabase logs in dashboard
- Check Vercel/server logs