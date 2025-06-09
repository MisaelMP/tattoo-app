#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug info
echo "CLOUDINARY_CLOUD_NAME is set: ${CLOUDINARY_CLOUD_NAME:+true}"
echo "CLOUDINARY_API_KEY is set: ${CLOUDINARY_API_KEY:+true}"
echo "CLOUDINARY_API_SECRET is set: ${CLOUDINARY_API_SECRET:+true}"

# Install dependencies
bundle install --without development test

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
