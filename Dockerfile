# Use the official Ruby image as base
FROM ruby:3.2.8

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the rest of the application
COPY . .

# Make entrypoint script executable
RUN chmod +x entrypoint.sh

# Precompile assets for production
RUN if [ "$RAILS_ENV" = "production" ]; then \
    bundle exec rake assets:precompile; \
    fi

# Expose port 3000
EXPOSE 3000

# Add a script to be executed every time the container starts
ENTRYPOINT ["./entrypoint.sh"]

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"] 