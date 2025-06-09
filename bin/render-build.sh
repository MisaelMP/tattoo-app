#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Clean and prepare assets
bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails assets:precompile

# Setup database
bundle exec rails db:migrate
