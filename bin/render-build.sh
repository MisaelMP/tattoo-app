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
until PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d postgres -c '\q' 2>/dev/null; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

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
