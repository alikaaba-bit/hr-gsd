#!/bin/bash
# setup.sh - One-command setup for hr-gsd
# Works on both Computer A and Computer B

set -e

echo "=== Setting up hr-gsd ==="
echo "Time: $(date)"
echo "Computer: $(hostname)"
echo ""

# Check Node.js version
echo "→ Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node 20.x:"
    echo "   brew install node@20"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "⚠️  Node.js version is $NODE_VERSION. Recommended: 20.x"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✓ Node.js $(node --version)"

# Check if npm exists
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found"
    exit 1
fi

echo "✓ npm $(npm --version)"

# Install dependencies
echo ""
echo "→ Installing dependencies..."
npm install

# Setup environment file
if [ ! -f .env.local ]; then
    echo ""
    echo "→ Creating .env.local from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env.local
        echo "✓ Created .env.local"
        echo ""
        echo "⚠️  IMPORTANT: Edit .env.local with your credentials:"
        echo "   - NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY"
        echo "   - ANTHROPIC_API_KEY (for AI report analysis)"
        echo ""
    else
        echo "⚠️  .env.example not found. Please create .env.local manually."
    fi
else
    echo "✓ .env.local already exists"
fi

# Setup Supabase (optional)
echo ""
read -p "Setup Supabase database? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v supabase &> /dev/null; then
        echo "→ Running Supabase migrations..."
        supabase link
        supabase db push
    else
        echo "⚠️  Supabase CLI not found. Install with: npm install -g supabase"
    fi
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit .env.local with your Supabase credentials"
echo "  2. Run: npm run dev (to start development server)"
echo "  3. Open: http://localhost:3000"
echo "  4. View dashboard: http://localhost:3000/dashboard"
echo ""
echo "Live URL: https://hr-gsd-production.up.railway.app"
echo ""
