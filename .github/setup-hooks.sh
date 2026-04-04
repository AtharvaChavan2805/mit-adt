#!/bin/bash

# Pre-commit hook setup script
# This script sets up pre-commit hooks for code quality checks

cd "$(dirname "$0")"
root_dir="$(pwd)"

echo "🔧 Setting up pre-commit hooks..."

# Create pre-commit hook
mkdir -p "$root_dir/.git/hooks"

cat > "$root_dir/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash

echo "🔍 Running pre-commit checks..."

# Check styled client
echo "📦 Checking client code..."
cd client
npm run lint --fix || exit 1

# Check server dependencies
echo "📦 Checking server code..."
cd ../server
npm list --depth=0 || true

cd ..
echo "✅ Pre-commit checks passed!"
EOF

chmod +x "$root_dir/.git/hooks/pre-commit"

echo "✅ Pre-commit hooks installed!"
echo ""
echo "📋 Hooks installed:"
echo "   - pre-commit: Runs ESLint on client code"
echo ""
echo "To disable a hook temporarily, use:"
echo "   git commit --no-verify"
