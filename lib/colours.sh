#!/usr/bin/env bash

# Text styles
RESET='\033[0m'
BOLD='\033[1m'

# Foreground colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'

# Symbols
TICK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"

# Message functions
function info() {
  echo -e "${CYAN}[INFO]${RESET}  $*"
}

function success() {
  echo -e "${GREEN}[OK]${RESET}    $*"
}

function warn() {
  echo -e "${YELLOW}[WARN]${RESET}  $*"
}

function error() {
  echo -e "${RED}[ERROR]${RESET} $*"
}
