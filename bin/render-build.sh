#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

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
