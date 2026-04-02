---
inclusion: auto
---

# Markdown Conversion Tool - Customization Guide

When users ask to customize PDF or Word styling, help them by editing the configuration files.

## PDF Styling Customization

**Configuration file:** `file_conversion_tool/.md2pdf.js`

### Common customization requests:

**Font size changes:**
- "Make the text bigger/smaller" → Adjust `font-size: 10.5pt` in body
- "Make headings bigger" → Adjust `font-size` in h1, h2, h3
- "Make tables smaller" → Adjust `font-size: 0.88em` in table

**Page margins:**
- "Increase/decrease margins" → Adjust `margin: { top, bottom, left, right }` in pdf_options
- "More space on sides" → Increase left/right margins
- "More space top/bottom" → Increase top/bottom margins

**Table styling:**
- "Change table colors" → Adjust `background-color` in th and tr:nth-child(even)
- "Remove table borders" → Modify `border` in th, td
- "Make table text bigger" → Adjust `font-size` in table

**Code block styling:**
- "Change code background color" → Adjust `background-color` in pre
- "Make code text smaller" → Adjust `font-size` in pre

### How to help:

1. Ask what they want to customize
2. Read the current `.md2pdf.js` file
3. Make the requested changes
4. Explain what you changed
5. Suggest they test with a sample markdown file

## Word Styling Customization

**Configuration file:** `file_conversion_tool/scripts/style-docx.py`

### Common customization requests:

**Table styling:**
- "Change table header color" → Modify `shading.set(qn('w:fill'), 'D9D9D9')` in add_table_borders()
- "Change alternating row colors" → Modify `shading.set(qn('w:fill'), 'F2F2F2')` in add_table_borders()
- "Remove table borders" → Comment out border-related code

**Code block styling:**
- "Change code background" → Modify `shading.set(qn('w:fill'), 'E8E8E8')` in style_code_blocks()
- "Change code font" → Modify `run.font.name = 'Courier New'` in style_code_blocks()
- "Make code text bigger/smaller" → Adjust `run.font.size = Pt(9)` in style_code_blocks()

### How to help:

1. Ask what they want to customize
2. Read the current `style-docx.py` file
3. Make the requested changes
4. Explain what you changed
5. Suggest they test with a sample markdown file

## Auto Page Break Customization

**Configuration file:** `file_conversion_tool/scripts/auto-pagebreak.py`

### Common customization requests:

**Threshold adjustments:**
- "Break pages more/less often" → Adjust `word_count_since_break > 800` in should_add_pagebreak_before_heading()
- "Change code block threshold" → Adjust `code_lines > 30` in process()

**Heading behavior:**
- "Don't break before H2" → Modify logic in should_add_pagebreak_before_heading()
- "Always break before H3" → Add H3 handling in should_add_pagebreak_before_heading()

### How to help:

1. Ask what behavior they want
2. Read the current `auto-pagebreak.py` file
3. Make the requested changes
4. Explain what you changed

## Example Interactions

**User:** "Make the PDF text bigger"
**You should:**
1. Read `file_conversion_tool/.md2pdf.js`
2. Change `font-size: 10.5pt` to `font-size: 12pt` in body
3. Explain: "I've increased the base font size from 10.5pt to 12pt in the PDF configuration"

**User:** "Change the table header color to blue"
**You should:**
1. Read `file_conversion_tool/scripts/style-docx.py`
2. Change `shading.set(qn('w:fill'), 'D9D9D9')` to `shading.set(qn('w:fill'), '4472C4')` (blue)
3. Explain: "I've changed the Word table header background to blue (hex color 4472C4)"

**User:** "Add more space around the page"
**You should:**
1. Read `file_conversion_tool/.md2pdf.js`
2. Increase margin values, e.g., from `20mm` to `30mm`
3. Explain: "I've increased all page margins from 20mm to 30mm for more whitespace"

## Important Notes

- Always read the file first before making changes
- Explain what you changed in simple terms
- Suggest testing with a sample file
- If they want to revert, you can restore the original values
- Color values: Use hex codes without # (e.g., 'D9D9D9' not '#D9D9D9')
