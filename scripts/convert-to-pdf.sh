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
CONFIG_FILE=".md2pdf.js"

echo -e "${BLUE}📄 Markdown to PDF Batch Converter${NC}"
echo "=================================="
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo "Config: $CONFIG_FILE"
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
  
  if [ -f "$CONFIG_FILE" ]; then
    npx md-to-pdf --config-file "$CONFIG_FILE" "$file" </dev/null 2>&1 | grep -E "(started|completed)" || true
  else
    npx md-to-pdf "$file" </dev/null 2>&1 | grep -E "(started|completed)" || true
  fi
  
  # Move the generated PDF to output directory
  source_pdf="${file%.md}.pdf"
  if [ -f "$source_pdf" ]; then
    mv "$source_pdf" "$output_file"
    echo -e "        → $output_file"
    count=$((count + 1))
  else
    echo -e "        ❌ Failed to generate PDF"
  fi
  echo ""
done < "$temp_list"

rm "$temp_list"

echo "=================================="
echo -e "${GREEN}✅ Conversion complete!${NC}"
echo "Converted $count file(s)"
echo "PDFs saved to: $OUTPUT_DIR"