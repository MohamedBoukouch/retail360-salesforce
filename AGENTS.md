# AGENTS.md - Retail360 Salesforce Project

## Project Overview
Retail360 is a Salesforce DX project for retail management featuring customer visits, product recommendations, sales performance tracking, and a comprehensive retail dashboard.

## CI/CD Pipeline

### GitHub Actions Workflow
The CI/CD pipeline is defined in `.github/workflows/ci-cd.yml` and runs on push to `main`, `develop`, or pull requests to `main`.

### Pipeline Jobs

1. **lint-and-format** - Runs Prettier format check and ESLint on all LWC JavaScript files
2. **lwc-jest** - Runs LWC Jest unit tests with coverage
3. **test-scratch-org** - Creates a scratch org, deploys metadata, runs Apex tests (100% pass required), deletes scratch org
4. **deploy-sandbox** - Deploys to sandbox on `develop` branch (requires `SF_LOGIN_URL` and `SF_AUTH_KEY_JSON` secrets)
5. **deploy-production** - Deploys to production on `main` branch (requires `SF_LOGIN_URL` and `SF_AUTH_KEY_JSON` secrets)

### Required GitHub Secrets
- `DEV_HUB_KEY` - JWT private key for Dev Hub authentication (base64 encoded)
- `SF_LOGIN_URL` - Salesforce login URL (e.g., `https://login.salesforce.com` or sandbox URL)
- `SF_AUTH_KEY_JSON` - JSON auth file for target org

### CI/CD Script
A helper script is available at `scripts/sh/cicd.sh`:
```bash
# Run all checks (lint + lwc tests + deploy + apex tests)
./scripts/sh/cicd.sh full --org Retail360Dev

# Skip LWC tests and deploy, just run Apex tests
./scripts/sh/cicd.sh test-apex --org Retail360Dev

# Run only lint
./scripts/sh/cicd.sh lint

# Deploy only
./scripts/sh/cicd.sh deploy --org Retail360Dev
```

### Scratch Org Config
- Config file: `config/project-scratch-def.json`
- Create with: `sf org create scratch -f config/project-scratch-def.json -a my-scratch -d 7`

## Test Commands

### LWC Jest Tests
```bash
npm run test:unit          # Run tests
npm run test:unit:coverage # Run with coverage
npm run test:unit:watch    # Watch mode
```

### Apex Tests
```bash
# Run all tests
sf apex run test --test-level RunLocalTests --code-coverage --result-format human --wait 10 --target-org Retail360Dev

# Run specific test class
sf apex run test --test-level RunSpecifiedTests --class-names MyTestClass --target-org Retail360Dev
```

### Lint & Format
```bash
npm run lint                # ESLint on LWC files
npm run prettier:verify     # Check formatting
npm run prettier            # Auto-fix formatting
```

## Org Information
- **Dev Org Alias**: `Retail360Dev`
- **API Version**: 67.0
- **Namespace**: (none)
- **Scratch Org Definition**: `config/project-scratch-def.json`

## Deployment Verification
After deploying, always verify by running Apex tests:
```bash
sf apex run test --test-level RunLocalTests --code-coverage --result-format human --wait 10 --target-org Retail360Dev
```
