#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Setup database - skip db:create as Render creates the DB for us
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails db:seed

# Clean and prepare assets
bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails assets:precompile
