#!/bin/bash
# T_inf_0 Framework — Auto-Install + Auto-Start Script
# Downloads, installs, and immediately starts the daemon in one command.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/matrixmail2026-pixel/t_inf_0_framework/main/autostart.sh)
#
# Or locally:
#   bash autostart.sh

set -e

# Configuration
REPO_URL="https://github.com/matrixmail2026-pixel/t_inf_0_framework.git"
INSTALL_DIR="${T_INF_0_HOME:-$HOME/.t_inf_0_framework}"
BRANCH="main"
INTERVAL_SECONDS="${T_INF_0_INTERVAL:-3600}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════╗"
echo "║   T_inf_0 Framework — Auto-Install + Start    ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Prerequisites
echo -e "${YELLOW}[Step 1/5] Checking prerequisites...${NC}"
missing_tools=()

if ! command -v git &> /dev/null; then
    missing_tools+=("git")
fi

if ! command -v python3 &> /dev/null; then
    missing_tools+=("python3")
fi

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo -e "${RED}Error: The following tools are missing:${NC}"
    printf '%s\n' "${missing_tools[@]}" | sed 's/^/  - /'
    echo ""
    echo -e "${YELLOW}On Ubuntu/Debian:${NC}"
    echo "  sudo apt-get update && sudo apt-get install -y git python3"
    echo ""
    echo -e "${YELLOW}On macOS:${NC}"
    echo "  brew install git python3"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ git and python3 are available${NC}"
echo ""

# Step 2: Clone or update repository
echo -e "${YELLOW}[Step 2/5] Setting up repository...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${CYAN}Directory exists. Updating...${NC}"
    cd "$INSTALL_DIR"
    git fetch origin "$BRANCH" 2>/dev/null || true
    git reset --hard origin/"$BRANCH" 2>/dev/null || echo -e "${YELLOW}Could not reset. Continuing with existing installation.${NC}"
else
    echo -e "${CYAN}Cloning repository...${NC}"
    mkdir -p "$(dirname "$INSTALL_DIR")"
    git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo -e "${GREEN}✓ Repository ready at $INSTALL_DIR${NC}"
echo ""

# Step 3: Make scripts executable
echo -e "${YELLOW}[Step 3/5] Configuring scripts...${NC}"
for script in t_inf_0_framework.py scheduler.py run_local.sh run_cron_update.sh start_daemon.sh stop_daemon.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
    fi
done

echo -e "${GREEN}✓ All scripts are executable${NC}"
echo ""

# Step 4: Generate initial feed
echo -e "${YELLOW}[Step 4/5] Generating initial feed...${NC}"
if python3 t_inf_0_framework.py > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Feed generated successfully${NC}"
    if [ -f feed.xml ]; then
        feed_size=$(wc -c < feed.xml)
        echo "  Feed size: $feed_size bytes"
    fi
else
    echo -e "${YELLOW}⚠ Feed generation skipped (network may be unavailable)${NC}"
    echo "  The scheduler will retry automatically."
fi
echo ""

# Step 5: Start daemon
echo -e "${YELLOW}[Step 5/5] Starting background daemon...${NC}"
if bash start_daemon.sh 2>/dev/null; then
    sleep 1
    if [ -f scheduler.pid ]; then
        PID=$(cat scheduler.pid)
        if kill -0 "$PID" 2>/dev/null; then
            echo -e "${GREEN}✓ Daemon started successfully (PID: $PID)${NC}"
        else
            echo -e "${RED}✗ Daemon failed to start${NC}"
            exit 1
        fi
    fi
else
    echo -e "${RED}✗ Failed to start daemon${NC}"
    exit 1
fi
echo ""

# Final summary
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════╗"
echo "║        Setup Complete and Running!            ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo -e "${BLUE}📍 Installation Directory:${NC}"
echo "   $INSTALL_DIR"
echo ""

echo -e "${BLUE}⏱️  Refresh Interval:${NC}"
echo "   $((INTERVAL_SECONDS / 60)) minutes ($INTERVAL_SECONDS seconds)"
echo ""

echo -e "${BLUE}📄 Generated Feed:${NC}"
echo "   $INSTALL_DIR/feed.xml"
echo ""

echo -e "${BLUE}📋 Logs:${NC}"
echo "   $INSTALL_DIR/scheduler.log"
echo ""

echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo ""
echo -e "${CYAN}View logs in real-time:${NC}"
echo "   tail -f $INSTALL_DIR/scheduler.log"
echo ""
echo -e "${CYAN}Check daemon status:${NC}"
echo "   ps aux | grep scheduler.py"
echo ""
echo -e "${CYAN}Stop daemon:${NC}"
echo "   cd $INSTALL_DIR && bash stop_daemon.sh"
echo ""
echo -e "${CYAN}Run once manually:${NC}"
echo "   cd $INSTALL_DIR && bash run_local.sh"
echo ""
echo -e "${CYAN}View the generated feed:${NC}"
echo "   cat $INSTALL_DIR/feed.xml"
echo ""
echo -e "${CYAN}Add to system cron:${NC}"
echo "   crontab -e"
echo "   # Add: 0 * * * * /bin/bash $INSTALL_DIR/run_cron_update.sh"
echo ""

echo -e "${CYAN}"
echo "════════════════════════════════════════════════"
echo "🚀 T_inf_0 Framework is now active and running!"
echo "════════════════════════════════════════════════"
echo -e "${NC}"
