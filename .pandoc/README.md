# Word Styling Configuration

## How Word Styling Works

Word documents get professional styling through a two-step process:

1. **Pandoc conversion**: Converts Markdown to Word using basic styles from `reference.docx`
2. **Python post-processing**: Applies professional formatting via `scripts/style-docx.py`

## Current Styling

The `style-docx.py` script automatically applies:

### Tables
- ✅ Black borders on all cells
- ✅ Header row with light gray background (D9D9D9)
- ✅ Alternating row colors (F2F2F2) for readability
- ✅ Bold text in header row

### Code Blocks
- ✅ Gray background box (E8E8E8) - matches PDF styling
- ✅ Monospace font (Courier New, 9pt)
- ✅ Proper indentation and spacing
- ✅ Distinct from regular text

### Headings
- Controlled by `reference.docx` template
- Heading 1, 2, 3 styles applied during Pandoc conversion

## How to Customize

### Customize Table Styling

Edit `scripts/style-docx.py` in the `add_table_borders()` function:

```python
# Change header row color
shading.set(qn('w:fill'), 'D9D9D9')  # Light gray - change this hex code

# Change alternating row color
shading.set(qn('w:fill'), 'F2F2F2')  # Very light gray - change this hex code

# Change border color
border.set(qn('w:color'), '000000')  # Black - change to any hex color
```

### Customize Code Block Styling

Edit `scripts/style-docx.py` in the `style_code_blocks()` function:

```python
# Change background color
shading.set(qn('w:fill'), 'E8E8E8')  # Light gray - change this hex code

# Change font
run.font.name = 'Courier New'  # Change to any monospace font

# Change font size
run.font.size = Pt(9)  # Change size (in points)

# Change indentation
paragraph.paragraph_format.left_indent = Inches(0.25)  # Adjust padding
```

### Customize Heading Styles

Edit `.pandoc/reference.docx`:

1. Open the template:
   ```bash
   open .pandoc/reference.docx  # macOS
   ```

2. Modify heading styles:
   - Right-click on text → "Styles" → "Modify Style"
   - Change Heading 1, 2, 3 fonts, sizes, colors
   - Save template

## Testing Your Changes

After customizing:

```bash
# Test on a single file
pandoc test.md -o test-temp.docx --reference-doc=.pandoc/reference.docx
python3 scripts/style-docx.py test-temp.docx test-styled.docx
rm test-temp.docx

# Open and verify
open test-styled.docx
```

## Color Reference

Common professional colors (hex codes):

- **Light Gray** (headers): `D9D9D9`, `CCCCCC`
- **Very Light Gray** (alternating rows): `F2F2F2`, `F5F5F5`
- **Code Background**: `E8E8E8`, `F0F0F0`
- **Dark Gray** (text): `333333`, `666666`
- **Black** (borders): `000000`

## Troubleshooting

**Tables still look plain**:
- Check that `style-docx.py` is being executed after Pandoc
- Verify python-docx is installed: `pip3 install python-docx`
- Check for errors in script output

**Code blocks don't have boxes**:
- Ensure code blocks use monospace font in Markdown (triple backticks)
- Check `style_code_blocks()` function is running
- Verify font detection logic in script

**Changes not applying**:
- Make sure you're running the styling script after Pandoc
- Use the batch script `convert-to-word.sh` which handles both steps
- Check file permissions: `chmod +x scripts/style-docx.py`

## Tips

- Keep a backup of your customized `style-docx.py`
- Test changes on a small document first
- Use consistent colors across tables and code blocks
- Match your organization's branding colors if needed

## Workflow

**Manual conversion:**
```bash
# Step 1: Pandoc
pandoc file.md -o temp.docx --reference-doc=.pandoc/reference.docx

# Step 2: Styling
python3 scripts/style-docx.py temp.docx file.docx

# Step 3: Cleanup
rm temp.docx
```

**Automated conversion (recommended):**
```bash
./scripts/convert-to-word.sh input/ output/
# Handles all steps automatically
```