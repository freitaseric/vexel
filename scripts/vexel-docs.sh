#!/usr/bin/env bash

RESET="\x1B[0m"
COLOR_RED="\x1B[38;5;9m"
COLOR_AQUA="\x1B[38;5;14m"
COLOR_GREEN="\x1B[38;5;10m"

if ! command -v "zig" &> /dev/null; then
  echo -e "${COLOR_RED}ERROR: The \"zig\" compiler is not installed!$RESET" >&2
  exit 1
fi
if ! command -v "python" &> /dev/null; then
  echo -e "${COLOR_RED}ERROR: The \"python\" interpreter is not installed!$RESET" >&2
  exit 1
fi

echo -e "${COLOR_AQUA}Generating documentation!$RESET"
zig build docs --summary all

echo
echo -e "${COLOR_GREEN}Documentation successfully generated!$RESET"

echo -e "${COLOR_AQUA}Running http server on documentation directory...$RESET"
python -m http.server 8080 -d zig-out/docs/
