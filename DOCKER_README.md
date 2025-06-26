# Docker Setup for Tattoo App

This guide will help you set up and run the Tattoo App using Docker.

## Prerequisites

- Docker and Docker Compose installed on your system
- Git (to clone the repository)

## Quick Start

### 1. Clone and Setup

```bash
# Clone the repository (if not already done)
git clone <your-repo-url>
cd tattoo-app

# Copy the environment file
cp env.example .env

# Edit the .env file with your actual values
# Especially important: RAILS_MASTER_KEY and CLOUDINARY_URL
```

### 2. Environment Configuration

Edit the `.env` file with your actual values:

```bash
# Get your Rails master key from config/master.key
RAILS_MASTER_KEY=your_actual_master_key_here

# Set your Cloudinary credentials
CLOUDINARY_URL=cloudinary://your_api_key:your_api_secret@your_cloud_name
```

### 3. Build and Run

```bash
# Build the Docker images
docker compose build

# Start the services
docker compose up

# Or run in detached mode
docker compose up -d
```

### 4. Database Setup

```bash
# Create and migrate the database
docker compose exec web bundle exec rake db:create
docker compose exec web bundle exec rake db:migrate

# Optional: Seed the database
docker compose exec web bundle exec rake db:seed
```

### 5. Access the Application

- **Web Application**: http://localhost:3000
- **Database**: localhost:5432 (postgres/password)

## Development Workflow

### Running Commands

```bash
# Rails console
docker compose exec web bundle exec rails console

# Run tests
docker compose exec web bundle exec rspec

# Run migrations
docker compose exec web bundle exec rake db:migrate

# Install new gems
docker compose exec web bundle install

# View logs
docker compose logs -f web
```

### Code Changes

The application code is mounted as a volume, so changes to your local files will be reflected immediately in the container.

### Stopping Services

```bash
# Stop all services
docker compose down

# Stop and remove volumes (WARNING: This will delete your database)
docker compose down -v
```

## Production Deployment

### Using Production Compose File

```bash
# Set production environment variables
export RAILS_ENV=production
export DATABASE_PASSWORD=your_secure_password
export DATABASE_USER=your_db_user
export DATABASE_NAME=your_db_name

# Build and run production setup
docker compose -f docker-compose.prod.yml up -d
```

### Environment Variables for Production

Create a `.env.production` file:

```bash
RAILS_ENV=production
DATABASE_PASSWORD=your_secure_password
DATABASE_USER=your_db_user
DATABASE_NAME=your_db_name
RAILS_MASTER_KEY=your_master_key
CLOUDINARY_URL=your_cloudinary_url
```

## Troubleshooting

### Common Issues

1. **Port already in use**

   ```bash
   # Check what's using port 3000
   lsof -i :3000

   # Or change the port in docker-compose.yml
   ports:
     - "3001:3000"
   ```

2. **Database connection issues**

   ```bash
   # Check if database is running
   docker compose ps

   # View database logs
   docker compose logs db
   ```

3. **Permission issues with entrypoint.sh**

   ```bash
   # Make sure the file is executable
   chmod +x entrypoint.sh
   ```

4. **Asset compilation issues**
   ```bash
   # Precompile assets manually
   docker compose exec web bundle exec rake assets:precompile
   ```

### Logs and Debugging

```bash
# View all logs
docker compose logs

# View specific service logs
docker compose logs web
docker compose logs db

# Follow logs in real-time
docker compose logs -f web
```

### Database Management

```bash
# Connect to PostgreSQL
docker compose exec db psql -U postgres -d tatoo_app_development

# Backup database
docker compose exec db pg_dump -U postgres tatoo_app_development > backup.sql

# Restore database
docker compose exec -T db psql -U postgres tatoo_app_development < backup.sql
```

## Docker Commands Reference

### Basic Commands

```bash
# Build images
docker compose build

# Start services
docker compose up

# Start in background
docker compose up -d

# Stop services
docker compose down

# View running containers
docker compose ps

# View logs
docker compose logs

# Execute command in container
docker compose exec web <command>
```

### Advanced Commands

```bash
# Rebuild without cache
docker compose build --no-cache

# Scale services
docker compose up --scale web=3

# View resource usage
docker stats

# Clean up unused resources
docker system prune
```

## File Structure

```
tattoo-app/
├── Dockerfile                 # Main application container
├── docker-compose.yml         # Development environment
├── docker-compose.prod.yml    # Production environment
├── entrypoint.sh             # Container startup script
├── .dockerignore             # Files to exclude from build
├── env.example               # Environment variables template
└── DOCKER_README.md          # This file
```

## Security Notes

1. **Never commit sensitive data** like API keys or passwords
2. **Use environment variables** for all configuration
3. **Keep your Rails master key secure**
4. **Use strong passwords** for production databases
5. **Regularly update base images** for security patches

## Performance Tips

1. **Use volume caching** for bundle and node_modules
2. **Enable Docker BuildKit** for faster builds
3. **Use multi-stage builds** for production images
4. **Optimize asset compilation** in production

## Support

If you encounter issues:

1. Check the logs: `docker compose logs`
2. Verify environment variables are set correctly
3. Ensure all required services are running
4. Check Docker and Docker Compose versions are compatible
