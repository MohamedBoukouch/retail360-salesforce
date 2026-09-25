#!/usr/bin/env bash
# CI/CD helper scripts for Retail360 Salesforce project
# Usage: ./scripts/sh/cicd.sh [command]
# Commands:
#   setup       - Install npm dependencies
#   lint        - Run ESLint and Prettier checks
#   test        - Run LWC Jest tests with coverage
#   deploy      - Deploy source to target org (requires --org)
#   test-apex   - Run Apex tests on target org (requires --org)
#   full        - Run all checks (lint, test, deploy, test-apex)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$PROJECT_ROOT"

ORG=""
SKIP_LINT=false
SKIP_LWC=false
SKIP_DEPLOY=false

usage() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  setup      - Install npm dependencies"
    echo "  lint       - Run ESLint and Prettier checks"
    echo "  test       - Run LWC Jest tests with coverage"
    echo "  deploy     - Deploy source to target org"
    echo "  test-apex  - Run Apex tests on target org"
    echo "  full       - Run all checks (lint, test, deploy, test-apex)"
    echo ""
    echo "Options:"
    echo "  --org <alias>    Target org alias (default: Retail360Dev)"
    echo "  --skip-lint      Skip lint checks"
    echo "  --skip-lwc       Skip LWC tests"
    echo "  --skip-deploy    Skip deployment"
    echo "  -h, --help       Show this help message"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        setup|lint|test|deploy|test-apex|full)
            COMMAND="$1"
            shift
            ;;
        --org)
            ORG="$2"
            shift 2
            ;;
        --skip-lint)
            SKIP_LINT=true
            shift
            ;;
        --skip-lwc)
            SKIP_LWC=true
            shift
            ;;
        --skip-deploy)
            SKIP_DEPLOY=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

ORG="${ORG:-Retail360Dev}"

run_setup() {
    echo "=== Installing npm dependencies ==="
    npm ci
}

run_lint() {
    echo "=== Running Prettier check ==="
    npm run prettier:verify || { echo "Prettier failed"; exit 1; }
    echo "=== Running ESLint ==="
    npm run lint || { echo "ESLint failed"; exit 1; }
}

run_lwc_tests() {
    echo "=== Running LWC Jest tests ==="
    npm run test:unit:coverage || { echo "LWC tests failed"; exit 1; }
}

run_deploy() {
    echo "=== Deploying to org: $ORG ==="
    sf project deploy start --source-dir force-app/main/default --target-org "$ORG" --wait 10 || { echo "Deploy failed"; exit 1; }
}

run_apex_tests() {
    echo "=== Running Apex tests on: $ORG ==="
    sf apex run test --test-level RunLocalTests --code-coverage --result-format human --wait 10 --target-org "$ORG" || { echo "Apex tests failed"; exit 1; }
}

case "${COMMAND:-full}" in
    setup)
        run_setup
        ;;
    lint)
        run_lint
        ;;
    test)
        run_lwc_tests
        ;;
    deploy)
        run_deploy
        ;;
    test-apex)
        run_apex_tests
        ;;
    full)
        if [ "$SKIP_LINT" = false ]; then
            run_lint
        fi
        if [ "$SKIP_LWC" = false ]; then
            run_lwc_tests
        fi
        if [ "$SKIP_DEPLOY" = false ]; then
            run_deploy
            run_apex_tests
        fi
        ;;
esac

echo "=== All checks passed ==="
