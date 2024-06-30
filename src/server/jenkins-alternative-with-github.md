### Migrating from Jenkins to GitHub Actions for CI/CD

#### Introduction
Jenkins has been a go-to tool for CI/CD for many developers. However, it can be heavy and complex for smaller projects or when simplicity is desired. In this blog post, I will walk you through my experience migrating from Jenkins to GitHub Actions for CI/CD, highlighting the reasons for the switch and the steps taken to implement a new workflow.

#### Prerequisites
Before you start the migration, ensure you have the following:
- A GitHub repository for your project.
- Access to your VPS (Virtual Private Server) where the application will be deployed.
- SSH keys generated and configured for your VPS.
- GitHub secrets configured for storing sensitive information like SSH keys.

#### Why Migrate from Jenkins to GitHub Actions?
- **Complexity and Maintenance**: Jenkins requires managing a separate server and handling its updates and maintenance, which can be time-consuming.
- **Performance**: Jenkins can be resource-intensive, which might be overkill for smaller projects.
- **Integration**: GitHub Actions provides seamless integration with GitHub repositories, making it easier to manage workflows within the same platform.
- **Simplicity**: GitHub Actions offers a straightforward YAML configuration, which is easier to read and manage compared to Jenkins' XML-based configurations.

being small but absolute working workaround works as follows.

- This workflow run on push on `main` branch and deploys in github and then only in vps.

![](https://null.pwnwriter.xyz/closing-dinosaur.png)

In this guide, we'll be using [appleboy/ssh-action](https://github.com/appleboy/ssh-action), which lets you ssh into the server and run particular script.

For this workflow, we'll first need to have our ssh keys in our vps and the user must be able to login via ssh.

You'll want to generate ssh keys and then put your public keys in `authorized_keys`, which simply lets the current user ssh into the sever.

#### Setting Up the GitHub Actions Workflow
After generating ssh keys, put your:
- PRIVATE_KEY, USERNAME, and HOST in your repository's secrets variables.

Here’s the GitHub Actions workflow that I set up to build and deploy my web application to a VPS:

```yaml
name: Test the web app and deploy on vps

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Install Nix package manager
        uses: DeterminateSystems/nix-installer-action@main

      - name: Install Node.js and pnpm
        run: |
          nix profile install nixpkgs#nodejs_22
          nix profile install nixpkgs#nodePackages_latest.pnpm

      - name: Build website
        run: |
          pnpm install
          pnpm run build

  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy over the vps
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.PRIVATE_KEY }}
          port: 22
          script: |
            cd ~/source_dir/
            bash ./.github/deployer.sh
```


A graph of this workflow
![](https://null.pwnwriter.xyz/unified-bull.png)

### The deployer script

The following script is ran by github actions on github build success

```bash
#!/usr/bin/env bash

# Written by @pwnwriter
# This script builds the Nest Nepal website. If the build fails, it attempts to build from the previous commit.

### Variables

USER="ubuntu"
REPO_DIR="/home/${USER}/repo_name"
INFO_DIR="/home/${USER}/repo_name-log"
LOG_FILE="$INFO_DIR/build.log"
SERVER_LOG="$INFO_DIR/server.log"
PORT=3002

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# -------------------- Helper functions ---------

# Appends log messages
append_log() {
    printf '%s - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

# Prints informational messages
print_info() {
    local message="${1}"
    printf "${YELLOW}[INFO]${NC} %s\n" "$message"
    append_log "[INFO] $message"
}

# Prints success messages
print_success() {
    local message="${1}"
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$message"
    append_log "[SUCCESS] $message"
}

# Prints error messages
print_error() {
    local message="${1}"
    printf "${RED}[ERROR]${NC} %s\n" "$message"
    append_log "[ERROR] $message"
}

# Creates log directories
create_log_dirs() {
    print_info "Creating log directories"
    mkdir -p "$INFO_DIR" || {
        print_error "Failed to create log directory"
        exit 1
    }
}

# Kills the current running process $port
kill_existing() {
    local pid
    pid=$(ss -lptn "sport = :$PORT" | grep -oP '(?<=pid=)\d+')
    if [ -n "$pid" ]; then
        print_info "Killing existing process with PID $pid"
        kill -9 "$pid" || {
            print_error "Failed to kill process with PID $pid"
            exit 1
        }
    else
        print_info "No existing process found on port $PORT"
    fi
}

# Builds the website
website_build() {
    print_info "Installing required modules"
    pnpm install 2>&1 | tee -a "$LOG_FILE" || {
        print_error "Failed to install modules"
        return 1
    }

    print_info "Building website"
    pnpm run build 2>&1 | tee -a "$LOG_FILE"
    if [ $? -eq 0 ]; then
        print_success "Build successful, starting website"
        kill_existing
        nohup pnpm start >>"$SERVER_LOG" 2>&1 &
        print_success "Website is live and running"
    else
        print_error "Build failed"
        return 1
    fi
}

# Main function
main() {
    cd "$REPO_DIR" || {
        print_error "Unable to change directory to $REPO_DIR"
        exit 1
    }

    print_info "Pulling latest changes from the main branch"
    git pull origin main --rebase || {
        print_error "Failed to pull latest changes from main branch"
        exit 1
    }

    create_log_dirs
    website_build

    if [ $? -ne 0 ]; then
        print_info "Build failed, attempting to build from previous commit"
        print_info "Reverting to previous commit"
        git checkout HEAD~ || {
            print_error "Failed to revert to previous commit"
            exit 1
        }
        website_build || {
            print_error "Build from previous commit failed"
            exit 1
        }
    fi
}

# Execute
main

```

![](https://null.pwnwriter.xyz/sharp-pangolin.png)
