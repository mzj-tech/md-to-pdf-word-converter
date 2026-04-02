#!/bin/bash

# Batch Markdown to PDF Converter
# Converts all markdown files in a directory to PDF format

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SOURCE_DIR="${1:-.}"
OUTPUT_DIR="${2:-./output/pdf}"
AUTO_PAGEBREAK=true
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$(dirname "$SCRIPT_DIR")/.md2pdf.js"
PAGEBREAK_SCRIPT="$SCRIPT_DIR/auto-pagebreak.py"

# Check for --no-auto-pagebreak flag to disable
if [ "$3" = "--no-auto-pagebreak" ]; then
  AUTO_PAGEBREAK=false
fi

echo -e "${BLUE}📄 Markdown to PDF Batch Converter${NC}"
echo "=================================="
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo "Config: $CONFIG_FILE"
echo "Auto Page Breaks: Enabled (use --no-auto-pagebreak to disable)"
echo ""

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  Warning: Config file $CONFIG_FILE not found. Using defaults."
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Counter
count=0

# Find and convert all .md files
# Use a temp file to store the list
temp_list=$(mktemp)
find "$SOURCE_DIR" -name "*.md" -type f > "$temp_list"

while IFS= read -r file; do
  filename=$(basename "$file" .md)
  relative_path=$(dirname "${file#$SOURCE_DIR/}")
  
  # Create subdirectory structure in output
  output_subdir="$OUTPUT_DIR/$relative_path"
  mkdir -p "$output_subdir"
  
  output_file="$output_subdir/$filename.pdf"
  
  echo -e "${GREEN}Converting:${NC} $file"
  
  # Process file (with optional auto page breaks)
  process_file="$file"
  if [ "$AUTO_PAGEBREAK" = true ]; then
    temp_md="${file%.md}.pagebreak.md"
    python3 "$PAGEBREAK_SCRIPT" "$file" "$temp_md" 2>/dev/null
    process_file="$temp_md"
  fi
  
  if [ -f "$CONFIG_FILE" ]; then
    npx md-to-pdf --config-file "$CONFIG_FILE" "$process_file" </dev/null 2>&1 | grep -E "(started|completed)" || true
  else
    npx md-to-pdf "$process_file" </dev/null 2>&1 | grep -E "(started|completed)" || true
  fi
  
  # Move the generated PDF to output directory
  source_pdf="${process_file%.md}.pdf"
  if [ -f "$source_pdf" ]; then
    mv "$source_pdf" "$output_file"
    echo -e "        → $output_file"
    count=$((count + 1))
  else
    echo -e "        ❌ Failed to generate PDF"
  fi
  
  # Clean up temp file
  if [ "$AUTO_PAGEBREAK" = true ]; then
    rm -f "$temp_md"
  fi
  
  echo ""
done < "$temp_list"

rm "$temp_list"

echo "=================================="
echo -e "${GREEN}✅ Conversion complete!${NC}"
echo "Converted $count file(s)"
echo "PDFs saved to: $OUTPUT_DIR"
