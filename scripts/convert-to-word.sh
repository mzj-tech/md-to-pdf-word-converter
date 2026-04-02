#!/bin/bash

# Batch Markdown to Word Converter
# Converts all markdown files in a directory to Word (DOCX) format
# Applies professional styling (table borders, code block backgrounds)

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
SOURCE_DIR="${1:-.}"
AUTO_PAGEBREAK=true
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REFERENCE_DOC=".pandoc/reference.docx"
STYLE_SCRIPT="$SCRIPT_DIR/style-docx.py"
PAGEBREAK_SCRIPT="$SCRIPT_DIR/auto-pagebreak.py"

# Check for --no-auto-pagebreak flag to disable
if [ "$2" = "--no-auto-pagebreak" ]; then
  AUTO_PAGEBREAK=false
fi

echo -e "${BLUE}📄 Markdown to Word Batch Converter${NC}"
echo "===================================="
echo "Source: $SOURCE_DIR"

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
  echo -e "${YELLOW}⚠️  Error: pandoc is not installed${NC}"
  echo "Please install pandoc:"
  echo "  macOS: brew install pandoc"
  echo "  Ubuntu: sudo apt-get install pandoc"
  echo "  Windows: https://pandoc.org/installing.html"
  exit 1
fi

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
  echo -e "${YELLOW}⚠️  Error: python3 is not installed${NC}"
  echo "Please install Python 3"
  exit 1
fi

# Check if python-docx is installed
if ! python3 -c "import docx" 2>/dev/null; then
  echo -e "${YELLOW}⚠️  Installing python-docx for styling...${NC}"
  pip3 install python-docx
fi

# Check for reference document
if [ -f "$REFERENCE_DOC" ]; then
  echo "Template: $REFERENCE_DOC"
  USE_REFERENCE=true
else
  echo "Template: Default (no custom template)"
  USE_REFERENCE=false
fi

echo "Auto Page Breaks: Enabled (use --no-auto-pagebreak to disable)"
echo ""

# Counter
count=0

# Find and convert all .md files
# Use a temp file to store the list
temp_list=$(mktemp)
find "$SOURCE_DIR" -name "*.md" -type f > "$temp_list"

while IFS= read -r file; do
  filename=$(basename "$file" .md)
  output_file="${file%.md}.docx"
  temp_file="${file%.md}.temp.docx"
  
  echo -e "${GREEN}Converting:${NC} $file"
  
  # Step 0: Auto page breaks (if enabled)
  process_file="$file"
  if [ "$AUTO_PAGEBREAK" = true ]; then
    temp_md="${file%.md}.pagebreak.md"
    python3 "$PAGEBREAK_SCRIPT" "$file" "$temp_md" 2>/dev/null
    process_file="$temp_md"
  fi
  
  # Step 1: Pandoc conversion
  if [ "$USE_REFERENCE" = true ]; then
    pandoc "$process_file" -o "$temp_file" \
      --reference-doc="$REFERENCE_DOC" \
      2>&1 | grep -v "^$" || true
  else
    pandoc "$process_file" -o "$temp_file" \
      2>&1 | grep -v "^$" || true
  fi
  
  # Step 2: Apply professional styling
  python3 "$STYLE_SCRIPT" "$temp_file" "$output_file" 2>&1 | sed 's/^/  /'
  
  # Clean up temp files
  rm "$temp_file"
  if [ "$AUTO_PAGEBREAK" = true ]; then
    rm -f "$temp_md"
  fi
  
  echo -e "        → $output_file"
  
  count=$((count + 1))
  echo ""
done < "$temp_list"

rm "$temp_list"

echo "===================================="
echo -e "${GREEN}✅ Conversion complete!${NC}"
echo "Converted $count file(s)"
