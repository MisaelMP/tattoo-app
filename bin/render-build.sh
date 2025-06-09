#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Setup database
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# Clean and prepare assets
bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails assets:precompile
