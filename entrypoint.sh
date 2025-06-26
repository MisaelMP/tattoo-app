#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Install dependencies if they don't exist
if [ ! -d "node_modules" ]; then
  echo "Installing Node.js dependencies..."
  npm install
fi

# Wait for database to be ready
echo "Waiting for database..."
until /usr/bin/pg_isready -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER; do
  echo "Database is unavailable - sleeping"
  sleep 1
done

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate

# Seed database if needed
if [ "$RAILS_ENV" = "development" ] && [ "$SEED_DATABASE" = "true" ]; then
  echo "Seeding database..."
  bundle exec rake db:seed
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@" 