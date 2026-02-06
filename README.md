# GitHub Actions Self-Hosted Runner on Railway

This deploys a GitHub Actions runner to Railway that will pick up jobs from your repository.

## Setup

### 1. Create a GitHub Personal Access Token

Go to: https://github.com/settings/tokens/new

Required scopes:
- `repo` (full control of private repositories)

Copy the token.

### 2. Deploy to Railway

```bash
# Install Railway CLI if needed
npm install -g @railway/cli

# Login to Railway
railway login

# Create new project (or use existing)
railway init

# Set environment variables
railway variables set GITHUB_OWNER=edmondtam1
railway variables set GITHUB_REPO=heartbeet
railway variables set GITHUB_TOKEN=ghp_your_token_here

# Deploy
railway up
```

### 3. Update CI workflow to use self-hosted runner

In `.github/workflows/ci.yml`, change:
```yaml
runs-on: ubuntu-latest
```
to:
```yaml
runs-on: self-hosted
```

Or use labels for specific jobs:
```yaml
runs-on: [self-hosted, railway]
```

## Cost

- Runner only uses CPU when jobs are running
- Idle time is minimal (~$0.50/month)
- Active CI: ~$1-3/month depending on usage

## Troubleshooting

Check Railway logs:
```bash
railway logs
```

Verify runner is connected:
- Go to: https://github.com/edmondtam1/heartbeet/settings/actions/runners
- Should see "railway-runner-xxx" listed as online
