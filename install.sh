#!/bin/bash

# Installation script for md-to-pdf-word-converter
# Usage: curl -sSL https://raw.githubusercontent.com/mzj-tech/md-to-pdf-word-converter/main/install.sh | bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}📦 Installing Markdown to PDF/Word Converter${NC}"
echo "=============================================="
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
  echo -e "${YELLOW}⚠️  Warning: Not in a git repository${NC}"
  echo "This script will create files in the current directory."
  read -p "Continue? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Create installation directory
INSTALL_DIR="file_conversion_tool"
echo -e "${BLUE}📥 Downloading files...${NC}"

# Check if directory already exists
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}⚠️  Warning: $INSTALL_DIR already exists${NC}"
  read -p "Overwrite? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
  rm -rf "$INSTALL_DIR"
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)

# Clone the repository
git clone --depth 1 https://github.com/mzj-tech/md-to-pdf-word-converter.git "$TEMP_DIR" 2>/dev/null

# Create installation directory and copy files
echo -e "${BLUE}📋 Installing to $INSTALL_DIR/...${NC}"
mkdir -p "$INSTALL_DIR"
cp -r "$TEMP_DIR/scripts" "$INSTALL_DIR/"
cp "$TEMP_DIR/.md2pdf.js" "$INSTALL_DIR/"

# Copy Kiro hooks (if they exist in the repo)
if [ -d "$TEMP_DIR/.kiro/hooks" ]; then
  echo -e "${BLUE}📌 Installing Kiro hooks...${NC}"
  mkdir -p .kiro/hooks
  
  # Only copy conversion-related hooks, don't overwrite existing hooks
  if [ -f "$TEMP_DIR/.kiro/hooks/auto-convert-word.json" ]; then
    cp "$TEMP_DIR/.kiro/hooks/auto-convert-word.json" .kiro/hooks/
    echo -e "${GREEN}✓${NC} Installed auto-convert-word hook"
  fi
  
  if [ -f "$TEMP_DIR/.kiro/hooks/auto-convert-pdf.json" ]; then
    cp "$TEMP_DIR/.kiro/hooks/auto-convert-pdf.json" .kiro/hooks/
    echo -e "${GREEN}✓${NC} Installed auto-convert-pdf hook"
  fi
fi

# Copy Claude configuration (if it exists in the repo)
if [ -d "$TEMP_DIR/.claude" ]; then
  echo -e "${BLUE}📌 Installing Claude Code configuration...${NC}"
  mkdir -p .claude
  
  # Copy all Claude config files, but don't overwrite existing ones
  for file in "$TEMP_DIR/.claude"/*; do
    filename=$(basename "$file")
    if [ ! -f ".claude/$filename" ]; then
      cp "$file" .claude/
      echo -e "${GREEN}✓${NC} Installed $filename"
    else
      echo -e "${YELLOW}⚠️${NC}  Skipped $filename (already exists)"
    fi
  done
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/scripts"/*.sh "$INSTALL_DIR/scripts"/*.py

echo -e "${GREEN}✅ Files installed!${NC}"
echo ""

# Check and install dependencies
echo -e "${BLUE}🔧 Checking dependencies...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
  echo -e "${YELLOW}⚠️  Node.js not found${NC}"
  echo "Install: brew install node"
  MISSING_DEPS=true
else
  echo -e "${GREEN}✓${NC} Node.js installed"
fi

# Check md-to-pdf
if ! command -v md-to-pdf &> /dev/null; then
  echo -e "${YELLOW}⚠️  md-to-pdf not found${NC}"
  echo "Install: npm install -g md-to-pdf"
  MISSING_DEPS=true
else
  echo -e "${GREEN}✓${NC} md-to-pdf installed"
fi

# Check Pandoc
if ! command -v pandoc &> /dev/null; then
  echo -e "${YELLOW}⚠️  Pandoc not found${NC}"
  echo "Install: brew install pandoc"
  MISSING_DEPS=true
else
  echo -e "${GREEN}✓${NC} Pandoc installed"
fi

# Check Python
if ! command -v python3 &> /dev/null; then
  echo -e "${YELLOW}⚠️  Python 3 not found${NC}"
  echo "Install: brew install python3"
  MISSING_DEPS=true
else
  echo -e "${GREEN}✓${NC} Python 3 installed"
fi

# Check python-docx
if ! python3 -c "import docx" 2>/dev/null; then
  echo -e "${YELLOW}⚠️  python-docx not found${NC}"
  echo "Installing python-docx..."
  pip3 install python-docx
else
  echo -e "${GREEN}✓${NC} python-docx installed"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=============================================="
if [ "$MISSING_DEPS" = true ]; then
  echo -e "${YELLOW}⚠️  Some dependencies are missing${NC}"
  echo "Please install them using the commands above."
else
  echo -e "${GREEN}✅ Installation complete!${NC}"
fi

echo ""
echo -e "${BLUE}📖 Usage:${NC}"
echo "  Convert to PDF:"
echo "    npx md-to-pdf --config-file file_conversion_tool/.md2pdf.js your-file.md"
echo ""
echo "  Convert to Word:"
echo "    ./file_conversion_tool/scripts/convert-to-word.sh docs/ output/"
echo ""
echo "  Batch convert to PDF:"
echo "    ./file_conversion_tool/scripts/convert-to-pdf.sh docs/ output/"
echo ""
echo -e "${BLUE}🪝 AI Assistant Integration:${NC}"
if [ -d .kiro/hooks ]; then
  echo "  ✓ Kiro hooks installed - auto-convert on save enabled!"
fi
if [ -d .claude ]; then
  echo "  ✓ Claude Code configuration installed!"
fi
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "  https://github.com/mzj-tech/md-to-pdf-word-converter"
