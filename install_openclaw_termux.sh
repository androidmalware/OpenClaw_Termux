#!/data/data/com.termux/files/usr/bin/bash
# install_openclaw_ubuntu.sh
# Purpose: Set up Termux + Ubuntu (proot), Node.js 22, OpenClaw, and a Node hijack shim.
# Finally runs: `openclaw onboard` and then `openclaw gateway --verbose`.
# Safe to re-run; it’s idempotent where possible.
# Detaisl: https://www.mobile-hacker.com/2026/02/11/how-to-install-openclaw-on-an-android-phone-and-control-it-via-whatsapp/

set -Eeuo pipefail

# ---------- Helpers ----------
section() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
die() { echo -e "\n[ERROR] $*" >&2; exit 1; }

# Run a command inside Ubuntu (proot-distro) as root
ub() { proot-distro login ubuntu -- bash -lc "$*"; }

export DEBIAN_FRONTEND=noninteractive
TERMUX_HOME="/data/data/com.termux/files/home"

# ---------- Termux baseline ----------
section "Request storage access (you may see a prompt on device)"
termux-setup-storage || true

section "Update Termux packages"
yes | pkg update || true
yes | pkg upgrade || true

section "Install Termux packages: proot-distro, termux-apk (if available)"
pkg install -y proot-distro || die "Failed to install proot-distro"
# 'termux-apk' may not exist in all mirrors; ignore failure if missing
pkg install -y termux-api || true

# ---------- Ubuntu (proot) ----------
section "Install/refresh Ubuntu proot-distro"
proot-distro install ubuntu || true

section "Update Ubuntu base (apt update/upgrade)"
ub "apt update && apt -y upgrade"

section "Install build and network tooling (curl git build-essential ca-certificates)"
ub "apt install -y curl git build-essential ca-certificates"

# ---------- Node.js 22 via NodeSource ----------
section "Install Node.js 22.x (NodeSource)"
ub "curl -fsSL https://deb.nodesource.com/setup_22.x | bash -"
ub "apt install -y nodejs"
ub "node -v && npm -v"

# ---------- OpenClaw ----------
section "Install OpenClaw (latest)"
ub "npm install -g openclaw@latest"

# ---------- Hijack shim ----------
section "Apply Node.js network interface hijack"
# Override os.networkInterfaces() to return an empty object
ub 'cat > /root/hijack.js << "EOF"
const os = require("os");
os.networkInterfaces = () => ({});
EOF'

# Add preload via NODE_OPTIONS to root’s bashrc (idempotent)
ub 'grep -q "NODE_OPTIONS=.*-r /root/hijack.js" ~/.bashrc || echo '\''export NODE_OPTIONS="-r /root/hijack.js"'\'' >> ~/.bashrc'
ub 'source ~/.bashrc || true'

# ---------- Final steps ----------
section "Run OpenClaw onboarding"
ub "openclaw onboard || true"

section "Start OpenClaw gateway (verbose) — this will stay running"
# Last command as requested:
ub "openclaw gateway --verbose"

# (No message here after gateway because the process is expected to run in foreground)