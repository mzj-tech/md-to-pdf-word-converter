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
OUTPUT_DIR="${2:-./output/docx}"
REFERENCE_DOC=".pandoc/reference.docx"
STYLE_SCRIPT="scripts/style-docx.py"

echo -e "${BLUE}📄 Markdown to Word Batch Converter${NC}"
echo "===================================="
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"

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

echo ""

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
  
  output_file="$output_subdir/$filename.docx"
  temp_file="$output_subdir/$filename.temp.docx"
  
  echo -e "${GREEN}Converting:${NC} $file"
  
  # Step 1: Pandoc conversion
  if [ "$USE_REFERENCE" = true ]; then
    pandoc "$file" -o "$temp_file" \
      --reference-doc="$REFERENCE_DOC" \
      2>&1 | grep -v "^$" || true
  else
    pandoc "$file" -o "$temp_file" \
      2>&1 | grep -v "^$" || true
  fi
  
  # Step 2: Apply professional styling
  python3 "$STYLE_SCRIPT" "$temp_file" "$output_file" 2>&1 | sed 's/^/  /'
  
  # Clean up temp file
  rm "$temp_file"
  
  echo -e "        → $output_file"
  
  count=$((count + 1))
  echo ""
done < "$temp_list"

rm "$temp_list"

echo "===================================="
echo -e "${GREEN}✅ Conversion complete!${NC}"
echo "Converted $count file(s)"
echo "Word files saved to: $OUTPUT_DIR"