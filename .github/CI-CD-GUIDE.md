# MIT-ADT CI/CD Setup

## Overview
This project uses GitHub Actions for automated testing, linting, building, and deployment.

## Workflows

### 1. CI Pipeline (`ci.yml`)
Runs on every push and pull request to `main` and `develop` branches.

**What it does:**
- Tests Node.js versions 18.x and 20.x
- Installs server dependencies
- Installs and lints client code
- Builds the React client
- Runs security vulnerability scanning with Trivy

**Trigger:** Push to `main`/`develop`, Pull Requests

### 2. Docker Build & Push (`docker-build.yml`)
Builds and pushes Docker images to Docker Hub.

**What it does:**
- Builds server Docker image
- Builds client Docker image
- Caches layers for faster builds
- Pushes to Docker Hub on main branch pushes and version tags

**Required Secrets:**
- `DOCKER_USERNAME` - Your Docker Hub username
- `DOCKER_PASSWORD` - Your Docker Hub access token

**Trigger:** Push to `main` branch or version tags (v*)

### 3. Deployment (`deploy.yml`)
Deploys the application to production server.

**What it does:**
- Pulls latest Docker images
- Restarts containers with `docker compose up -d`
- Runs database migrations

**Required Secrets:**
- `DEPLOY_PRIVATE_KEY` - SSH private key
- `DEPLOY_HOST` - Production server hostname
- `DEPLOY_USER` - SSH username

**Trigger:** Push to `main` branch or version tags

## Setting Up Secrets

### For Docker Push:
1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Create `DOCKER_USERNAME` secret
3. Create `DOCKER_PASSWORD` secret (use Docker Hub access token)

### For Production Deployment:
1. Create `DEPLOY_PRIVATE_KEY` - your SSH private key
2. Create `DEPLOY_HOST` - your production server IP/hostname
3. Create `DEPLOY_USER` - SSH user (usually `deploy` or `ubuntu`)

### For Dependabot Updates:
Update the `.github/dependabot.yml` file with your GitHub username in the reviewers field.

## Running Locally

### Test CI Pipeline:
```bash
# Server
cd server
npm install
npm run dev

# Client (in another terminal)
cd client
npm install
npm run lint
npm run build
```

### Build Docker Images:
```bash
# Build all services
docker compose build

# Run all services
docker compose up -d

# View logs
docker compose logs -f
```

## Status Badges

Add these to your README.md:

```markdown
![CI Pipeline](https://github.com/your-username/MIT-ADT/workflows/CI%20-%20Lint%20%26%20Test/badge.svg)
![Docker Build](https://github.com/your-username/MIT-ADT/workflows/Docker%20Build%20%26%20Push/badge.svg)
```

## Best Practices

1. **Commit Messages:** Use conventional commits (feat:, fix:, docs:, etc.)
2. **Branches:** Use `develop` for development, `main` for production
3. **Pull Requests:** Always create PR from feature branches to `develop`
4. **Version Tags:** Use semantic versioning (v1.0.0, v1.1.0, etc.)
5. **Docker Compose:** Always update docker-compose.yml in sync with Dockerfiles

## Troubleshooting

### Docker Build Fails
- Check Dockerfile syntax
- Ensure all COPY paths exist
- Check for missing dependencies in package.json

### Deployment Fails
- Verify SSH keys are correctly set
- Check DEPLOY_HOST and DEPLOY_USER
- Ensure `/path/to/app` exists on production server

### Lint Errors
- Run `npm run lint` locally first
- Fix issues before pushing
- Check `.eslintignore` for ignored files

## Future Improvements

- [ ] Add unit tests with Jest
- [ ] Add integration tests
- [ ] Add performance benchmarking
- [ ] Add code coverage reports
- [ ] Add automated changelog generation
- [ ] Add Slack notifications
- [ ] Add database backup before deploy
