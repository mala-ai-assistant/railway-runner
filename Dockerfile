FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm and yarn
RUN npm install -g pnpm yarn

# Create runner user
RUN useradd -m runner
WORKDIR /home/runner

# Download and extract GitHub Actions runner
ARG RUNNER_VERSION=2.321.0
RUN curl -o actions-runner-linux-x64.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf actions-runner-linux-x64.tar.gz \
    && rm actions-runner-linux-x64.tar.gz \
    && ./bin/installdependencies.sh

# Copy startup script
COPY start.sh /home/runner/start.sh
RUN chmod +x /home/runner/start.sh

# Change ownership
RUN chown -R runner:runner /home/runner

USER runner

ENTRYPOINT ["/home/runner/start.sh"]
# v2 - auto-PAT support
