#!/usr/bin/env bash
# ==============================================================
# install_terraform.sh — Installs Terraform via HashiCorp repo
# Usage: sudo bash install_terraform.sh
# ==============================================================

set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────
PACKAGE="terraform"
KEYRING_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
REPO_FILE="/etc/apt/sources.list.d/hashicorp.list"
GPG_URL="https://apt.releases.hashicorp.com/gpg"
APT_REPO_URL="https://apt.releases.hashicorp.com"

# ──────────────────────────────────────────────
# Logging helpers
# ──────────────────────────────────────────────
log()   { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; exit 1; }

# ──────────────────────────────────────────────
# Pre-flight checks
# ──────────────────────────────────────────────

check_os() {
  if [[ ! -f /etc/os-release ]]; then
    error "Cannot determine OS. /etc/os-release not found."
  fi
  source /etc/os-release
  log "Detected OS: $NAME $VERSION_ID"

  # Only support Debian/Ubuntu families
  if ! command -v apt &>/dev/null; then
    error "This script supports only Debian/Ubuntu-based systems (apt required)."
  fi
}

check_dependencies() {
  local deps=("wget" "gpg" "curl" "tee")
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      log "Installing missing dependency: $dep"
      apt-get install -y "$dep" || error "Failed to install $dep"
    fi
  done
}

# ──────────────────────────────────────────────
# Idempotency check
# ──────────────────────────────────────────────
check_already_installed() {
  if command -v "$PACKAGE" &>/dev/null; then
    local version
    version=$("$PACKAGE" version 2>/dev/null | head -1)
    warn "$PACKAGE is already installed: $version"
    read -rp "Reinstall/upgrade? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { log "Skipping installation."; exit 0; }
  fi
}

# ──────────────────────────────────────────────
# Installation
# ──────────────────────────────────────────────
add_gpg_key() {
  log "Adding HashiCorp GPG key..."
  wget -O- "$GPG_URL" \
    | gpg --dearmor \
    | tee "$KEYRING_PATH" > /dev/null
  log "GPG key saved to $KEYRING_PATH"
}

add_apt_repo() {
  log "Adding HashiCorp APT repository..."
  local codename
  codename=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release 2>/dev/null \
             || lsb_release -cs 2>/dev/null \
             || error "Cannot determine OS codename.")

  echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_PATH}] \
${APT_REPO_URL} ${codename} main" \
    | tee "$REPO_FILE" > /dev/null

  log "Repo file written: $REPO_FILE"
}

install_package() {
  log "Updating apt cache and installing $PACKAGE..."
  apt-get update -qq
  apt-get install -y "$PACKAGE" || error "Installation of $PACKAGE failed."
  log "$PACKAGE installed successfully: $($PACKAGE version | head -1)"
}

# ──────────────────────────────────────────────
# Cleanup (optional rollback on failure)
# ──────────────────────────────────────────────
cleanup_on_failure() {
  warn "Installation failed. Rolling back changes..."
  [[ -f "$KEYRING_PATH" ]] && rm -f "$KEYRING_PATH" && log "Removed keyring."
  [[ -f "$REPO_FILE" ]]    && rm -f "$REPO_FILE"    && log "Removed repo file."
}
trap cleanup_on_failure ERR

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
  
  check_os
  check_dependencies
  check_already_installed
  add_gpg_key
  add_apt_repo
  install_package
  log "Done! Run: $PACKAGE --version"
}

main "$@"