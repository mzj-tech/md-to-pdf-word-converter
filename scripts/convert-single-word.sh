#!/bin/bash

# Single Markdown to Word Converter
# Converts a single markdown file to Word (DOCX) format with professional styling

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 <input.md> [output.docx] [--no-auto-pagebreak]"
  echo ""
  echo "Options:"
  echo "  output.docx             Optional output path (defaults to same folder as input)"
  echo "  --no-auto-pagebreak     Disable automatic intelligent page breaks"
  echo ""
  echo "Examples:"
  echo "  $0 document.md"
  echo "  $0 document.md custom-output.docx"
  echo "  $0 document.md document.docx --no-auto-pagebreak"
  exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.md}.docx}"
AUTO_PAGEBREAK=true
TEMP_FILE="${OUTPUT_FILE%.docx}.temp.docx"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STYLE_SCRIPT="$SCRIPT_DIR/style-docx.py"
PAGEBREAK_SCRIPT="$SCRIPT_DIR/auto-pagebreak.py"

# Check for --no-auto-pagebreak flag (can be in position 2 or 3)
if [ "$2" = "--no-auto-pagebreak" ] || [ "$3" = "--no-auto-pagebreak" ]; then
  AUTO_PAGEBREAK=false
fi

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

# Step 0: Auto page breaks (if enabled)
PROCESS_FILE="$INPUT_FILE"
if [ "$AUTO_PAGEBREAK" = true ]; then
  echo "🔍 Adding intelligent page breaks..."
  TEMP_MD="${INPUT_FILE%.md}.pagebreak.md"
  python3 "$PAGEBREAK_SCRIPT" "$INPUT_FILE" "$TEMP_MD" 2>/dev/null
  PROCESS_FILE="$TEMP_MD"
fi

# Step 1: Pandoc conversion
pandoc "$PROCESS_FILE" -o "$TEMP_FILE" 2>&1 | grep -v "^$" || true

# Step 2: Apply professional styling
python3 "$STYLE_SCRIPT" "$TEMP_FILE" "$OUTPUT_FILE" 2>/dev/null

# Step 3: Clean up temp files
rm "$TEMP_FILE"
if [ "$AUTO_PAGEBREAK" = true ]; then
  rm "$TEMP_MD"
fi

echo -e "${GREEN}✅ Done!${NC}"
