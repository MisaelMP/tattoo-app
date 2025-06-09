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

# Simple database connection check
# echo "Checking database connection..."
# max_attempts=30
# counter=0

# until RAILS_ENV=production bundle exec rails runner 'begin; ActiveRecord::Base.connection; puts "Database connection successful"; rescue => e; puts "Connection failed: #{e.message}"; exit 1; end' || [ $counter -eq $max_attempts ]; do
#     echo "Waiting for database... (attempt $((counter + 1))/$max_attempts)"
#     counter=$((counter + 1))
#     sleep 2
# done

# if [ $counter -eq $max_attempts ]; then
#     echo "Could not connect to database after $max_attempts attempts"
#     exit 1
# fi

# echo "PostgreSQL is available"

# Clear tmp directory and assets
bundle exec rails tmp:clear
bundle exec rails assets:clean

# Precompile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Run migrations
echo "Running database migrations..."
bundle exec rails db:migrate
