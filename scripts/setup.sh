#!/bin/bash
# Setup script for Yu-Gi-Oh! Championship Database

echo "🎴 Yu-Gi-Oh! Championship Database Setup"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

echo "✅ Docker is installed"
echo ""

# Start the containers
echo "🚀 Starting PostgreSQL and pgAdmin containers..."
docker compose up -d

echo ""
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

# Check if database is ready
until docker exec yugioh_db pg_isready -U yugioh_user -d yugioh_championships &> /dev/null; do
    echo "   Still waiting for database..."
    sleep 2
done

echo ""
echo "✅ Database is ready!"
echo ""
echo "📊 Database Information:"
echo "   - Database: yugioh_championships"
echo "   - Host: localhost"
echo "   - Port: 5432"
echo "   - User: yugioh_user"
echo "   - Password: yugioh_pass"
echo ""
echo "🌐 pgAdmin Web Interface:"
echo "   - URL: http://localhost:5050"
echo "   - Email: admin@yugioh.com"
echo "   - Password: admin"
echo ""
echo "💡 To connect via command line:"
echo "   ./scripts/connect.sh"
echo ""
echo "✨ Setup complete! The data has been automatically loaded."
