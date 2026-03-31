#!/bin/bash

# Single Markdown to Word Converter
# Converts a single markdown file to Word (DOCX) format with professional styling

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <input.md> <output.docx>"
  echo ""
  echo "Example:"
  echo "  $0 document.md document.docx"
  exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
TEMP_FILE="${OUTPUT_FILE%.docx}.temp.docx"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STYLE_SCRIPT="$SCRIPT_DIR/style-docx.py"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo -e "${YELLOW}Error: Input file not found: $INPUT_FILE${NC}"
  exit 1
fi

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
  echo -e "${YELLOW}Error: pandoc is not installed${NC}"
  echo "Install: brew install pandoc"
  exit 1
fi

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
  echo -e "${YELLOW}Error: python3 is not installed${NC}"
  exit 1
fi

echo -e "${GREEN}Converting:${NC} $INPUT_FILE → $OUTPUT_FILE"

# Step 1: Pandoc conversion
pandoc "$INPUT_FILE" -o "$TEMP_FILE" 2>&1 | grep -v "^$" || true

# Step 2: Apply professional styling
python3 "$STYLE_SCRIPT" "$TEMP_FILE" "$OUTPUT_FILE" 2>/dev/null

# Step 3: Clean up temp file
rm "$TEMP_FILE"

echo -e "${GREEN}✅ Done!${NC}"
