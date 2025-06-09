#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug info
echo "Starting build script..."
echo "RAILS_ENV: $RAILS_ENV"
echo "DATABASE_URL is set: ${DATABASE_URL:+true}"
echo "CLOUDINARY_CLOUD_NAME is set: ${CLOUDINARY_CLOUD_NAME:+true}"
echo "CLOUDINARY_API_KEY is set: ${CLOUDINARY_API_KEY:+true}"
echo "CLOUDINARY_API_SECRET is set: ${CLOUDINARY_API_SECRET:+true}"

# Install dependencies
bundle install --without development test

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
sleep 10

# Clear tmp directory and assets
bundle exec rails tmp:clear
bundle exec rails assets:clean
bundle exec rails assets:precompile

# Database setup with retries
max_retries=5
counter=0
until bundle exec rails db:migrate || [ $counter -eq $max_retries ]; do
  echo "Migration failed. Retrying in 5 seconds..."
  counter=$((counter + 1))
  sleep 5
done

if [ $counter -eq $max_retries ]; then
  echo "Failed to migrate database after $max_retries attempts"
  exit 1
fi
  echo "Database connection not ready - sleeping"
  sleep 2
done

echo "Database connection ready!"

# Set up database
bundle exec rails db:migrate

echo "Postgres is available, running migrations..."

# Run assets precompilation first
bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails assets:precompile

# Setup database - skip db:create as Render creates the DB for us
if [ "$DATABASE_URL" != "" ]; then
    echo "Database URL is set, running migrations..."
    bundle exec rails db:migrate
else
    echo "Database URL is not set. Skipping database migrations."
fi
