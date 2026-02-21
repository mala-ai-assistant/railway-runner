#!/bin/bash
set -e

GITHUB_OWNER="${GITHUB_OWNER}"
GITHUB_REPO="${GITHUB_REPO:-heartbeet}"

# Auto-generate runner token from PAT if RUNNER_TOKEN not set
if [ -z "$RUNNER_TOKEN" ] && [ -n "$GITHUB_PAT" ]; then
    echo "Generating runner token from PAT..."
    RUNNER_TOKEN=$(curl -s -X POST \
        -H "Authorization: token ${GITHUB_PAT}" \
        "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token" \
        | jq -r .token)
    if [ -z "$RUNNER_TOKEN" ] || [ "$RUNNER_TOKEN" = "null" ]; then
        echo "Error: Failed to generate runner token from PAT"
        exit 1
    fi
    echo "Runner token generated successfully"
fi

if [ -z "$RUNNER_TOKEN" ]; then
    echo "Error: RUNNER_TOKEN or GITHUB_PAT must be set"
    exit 1
fi

# Configure runner
echo "Configuring runner..."
./config.sh --url "https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}" \
    --token "${RUNNER_TOKEN}" \
    --name "railway-runner-${RANDOM}" \
    --labels "railway,self-hosted,linux,x64" \
    --unattended \
    --replace

# Run
echo "Starting runner..."
./run.sh
