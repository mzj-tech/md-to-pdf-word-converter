# Markdown to PDF/Word Converter

**Tool-Agnostic Solution for Professional Document Generation**

Convert Markdown files to professionally formatted PDF and Word documents. Works with any AI assistant (Kiro, Claude, Cursor) or command line.

## 🎯 Features

- Professional formatting (headers, footers, page numbers, styled tables)
- Japanese and multilingual content support
- Batch processing for multiple files
- Professional table borders and alternating row shading
- Code blocks in gray boxes
- Public sector ready formatting
- Works with any AI tool or manually

## 📦 Use this tool in your project
Run this command in your project directory

```bash
curl -sSL https://raw.githubusercontent.com/mzj-tech/md-to-pdf-word-converter/main/install.sh | bash
```

This will:
- ✅ Download all necessary files to your project
- ✅ Check for dependencies
- ✅ Install python-docx automatically
- ✅ Make scripts executable
- ✅ Show you what's missing (if anything)

## 🛠️ Installation
### Prerequisites
**For PDF Generation:**
```bash
# Install md-to-pdf
npm install -g md-to-pdf
```

**For Word Generation:**
```bash
# Install Pandoc
brew install pandoc

# Install Python 3
brew install python3 

# Install python-docx for professional styling
pip3 install python-docx
```

## 🚀 Convert the files
### Single File Conversion

**Convert to PDF:**
```bash
npx md-to-pdf --config-file .md2pdf.js folder/document.md
```

**Convert to Word:**
```bash
# Step 1: Convert with Pandoc
pandoc folder/document.md -o temp.docx --reference-doc=.pandoc/reference.docx

# Step 2: Apply professional styling
python3 scripts/style-docx.py temp.docx folder/document.docx

# Step 3: Clean up
rm temp.docx
```

### Batch Conversion

**Convert all files in a directory:**
```bash
# PDF
./scripts/convert-to-pdf.sh folder/ output/pdf/

# Word
./scripts/convert-to-word.sh folder/ output/docx/
```

## 📖 Additional Documentation

- **[.pandoc/README.md](.pandoc/README.md)** - Word styling customization guide

## 🎨 Customization
### PDF Styling

Edit `.md2pdf.js` to change fonts, colors, margins, or table styles.

**Example customizations:**
```javascript
// Change table font size
table {
  font-size: 9pt;  // Reduce from 10pt
}

// Change page margins
pdf_options: {
  margin: { top: '30mm', bottom: '30mm', left: '25mm', right: '25mm' }
}
```

### Word Styling

Word documents get professional styling automatically via `scripts/style-docx.py`:
- ✅ Tables with borders and alternating row shading
- ✅ Code blocks in gray boxes (like PDF)
- ✅ Professional heading styles

The styling script applies:
- **Table borders**: Black borders with header row shading (light gray D9D9D9) and alternating row colors (F2F2F2)
- **Code block backgrounds**: Gray boxes (E8E8E8) around code blocks (detects Pandoc's "Source Code" style)
- **Professional spacing**: Proper indentation and padding

**To customize Word styling**, edit `scripts/style-docx.py`:
```python
# Change table header color
shading.set(qn('w:fill'), 'D9D9D9')  # Light gray - change this hex code

# Change code block background
shading.set(qn('w:fill'), 'E8E8E8')  # Light gray - change this hex code

# Change code block font
run.font.name = 'Courier New'  # Change to any monospace font
run.font.size = Pt(9)  # Change size
```

See `.pandoc/README.md` for more styling customization options.

### Page Breaks in PDF

Add page breaks in your markdown to prevent awkward splits:

```html
<div class="page-break"></div>
```

**Example usage:**
```markdown
## Section 1

Content for section 1...

<div class="page-break"></div>

## Section 2

Content for section 2 starts on a new page...
```

This ensures sections stay together and don't split across pages.