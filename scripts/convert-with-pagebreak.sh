#!/bin/bash

# Wrapper script for converting markdown to PDF with auto page breaks
# Usage: ./scripts/convert-with-pagebreak.sh input.md [--no-auto-pagebreak]

set -e

INPUT_FILE="$1"
AUTO_PAGEBREAK=true
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$(dirname "$SCRIPT_DIR")/.md2pdf.js"
PAGEBREAK_SCRIPT="$SCRIPT_DIR/auto-pagebreak.py"

# Check for --no-auto-pagebreak flag
if [ "$2" = "--no-auto-pagebreak" ]; then
  AUTO_PAGEBREAK=false
fi

# Validate input
if [ -z "$INPUT_FILE" ]; then
  echo "Usage: $0 input.md [--no-auto-pagebreak]"
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: File not found: $INPUT_FILE"
  exit 1
fi

# Process file
process_file="$INPUT_FILE"
if [ "$AUTO_PAGEBREAK" = true ]; then
  temp_md="${INPUT_FILE%.md}.pagebreak.md"
  python3 "$PAGEBREAK_SCRIPT" "$INPUT_FILE" "$temp_md" 2>/dev/null
  process_file="$temp_md"
fi

# Convert to PDF
if [ -f "$CONFIG_FILE" ]; then
  npx md-to-pdf --config-file "$CONFIG_FILE" "$process_file"
else
  npx md-to-pdf "$process_file"
fi

# Move PDF to original location
if [ "$AUTO_PAGEBREAK" = true ]; then
  source_pdf="${process_file%.md}.pdf"
  target_pdf="${INPUT_FILE%.md}.pdf"
  if [ -f "$source_pdf" ]; then
    mv "$source_pdf" "$target_pdf"
  fi
  # Clean up temp file
  rm -f "$temp_md"
fi
