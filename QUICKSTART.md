# T_inf_0 Framework — Quick Start

## One-Command Installation

Install the framework and set it up for immediate use:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/matrixmail2026-pixel/t_inf_0_framework/main/install.sh)
```

Or clone and install locally:

```bash
git clone https://github.com/matrixmail2026-pixel/t_inf_0_framework.git
cd t_inf_0_framework
bash install.sh
```

## One-Command Installation + Auto-Start Daemon

Install the framework, generate the initial feed, and start the background scheduler in one command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/matrixmail2026-pixel/t_inf_0_framework/main/autostart.sh)
```

Or locally:

```bash
git clone https://github.com/matrixmail2026-pixel/t_inf_0_framework.git
cd t_inf_0_framework
bash autostart.sh
```

This will:
1. ✓ Check for git and python3
2. ✓ Clone the repository (or update if it exists)
3. ✓ Make all scripts executable
4. ✓ Generate the initial feed
5. ✓ Start the background daemon immediately

## Quick Usage After Installation

### View logs in real-time
```bash
tail -f ~/.t_inf_0_framework/scheduler.log
```

### Stop the daemon
```bash
cd ~/.t_inf_0_framework && bash stop_daemon.sh
```

### Run once manually
```bash
cd ~/.t_inf_0_framework && bash run_local.sh
```

### View the generated feed
```bash
cat ~/.t_inf_0_framework/feed.xml
```

### Check daemon status
```bash
ps aux | grep scheduler.py
```

## Configuration

### Custom installation directory
```bash
T_INF_0_HOME=/opt/t_inf_0 bash autostart.sh
```

### Custom refresh interval
```bash
T_INF_0_INTERVAL=1800 bash autostart.sh  # 30 minutes
```

### Add to system cron
```bash
crontab -e
# Add:
0 * * * * /bin/bash ~/.t_inf_0_framework/run_cron_update.sh
```

## Troubleshooting

### Daemon won't start
```bash
# Check if Python can find the scheduler
python3 ~/.t_inf_0_framework/scheduler.py --once

# Check logs
cat ~/.t_inf_0_framework/scheduler.log
```

### Feed not updating
```bash
# Run once manually
cd ~/.t_inf_0_framework && python3 t_inf_0_framework.py

# Check if live scraping is working
curl https://charleyproject.org -s | head -20
```

### Permission denied errors
```bash
# Make scripts executable
chmod +x ~/.t_inf_0_framework/*.sh
chmod +x ~/.t_inf_0_framework/*.py
```

For more detailed documentation, see the main [README.md](README.md).
