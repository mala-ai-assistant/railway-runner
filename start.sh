#!/bin/bash
set -e

GITHUB_OWNER="${GITHUB_OWNER}"
GITHUB_REPO="${GITHUB_REPO:-heartbeet}"

if [ -z "$RUNNER_TOKEN" ]; then
    echo "Error: RUNNER_TOKEN must be set"
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
