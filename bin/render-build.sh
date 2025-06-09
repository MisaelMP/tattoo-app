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

# Print database connection info (without credentials)
echo "Database connection info:"
echo "POSTGRES_HOST: ${POSTGRES_HOST}"
echo "Database name from URL: $(echo $DATABASE_URL | awk -F'/' '{print $NF}')"

# Wait for PostgreSQL to be ready with explicit host check
echo "Waiting for PostgreSQL..."
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$(echo $DATABASE_URL | awk -F'/' '{print $NF}')" -c '\q' 2>/dev/null; do
  echo >&2 "Postgres is unavailable - sleeping"
  sleep 2
done

echo "PostgreSQL is available"

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
