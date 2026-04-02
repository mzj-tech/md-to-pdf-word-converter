#!/usr/bin/env python3
"""
Intelligent Auto Page Break Inserter for Markdown Files

Analyzes markdown structure and automatically inserts page breaks before:
- H1 headings (except the first one)
- H2 headings after long content sections (>800 words)
- Code blocks that would span pages (>30 lines)
- Tables after long content

Usage:
    python3 scripts/auto-pagebreak.py input.md output.md
    python3 scripts/auto-pagebreak.py input.md  # overwrites input.md
"""

import sys
import re
from pathlib import Path

class PageBreakInserter:
    def __init__(self, content):
        self.lines = content.split('\n')
        self.output = []
        self.word_count_since_break = 0
        self.line_index = 0
        
    def count_words(self, text):
        """Count words in a line (handles both English and Japanese)."""
        # Remove markdown syntax
        text = re.sub(r'[#*`\[\]()_~]', '', text)
        # Count words/characters
        words = len(text.split())
        # For CJK characters, count each character as a word
        cjk_chars = len(re.findall(r'[\u4e00-\u9fff\u3040-\u309f\u30a0-\u30ff]', text))
        return words + cjk_chars
    
    def is_heading(self, line, level=None):
        """Check if line is a heading, optionally of specific level."""
        match = re.match(r'^(#{1,6})\s+', line)
        if not match:
            return False
        if level is None:
            return True
        return len(match.group(1)) == level
    
    def is_code_block_start(self, line):
        """Check if line starts a code block."""
        return line.strip().startswith('```')
    
    def is_table_row(self, line):
        """Check if line is part of a table."""
        return '|' in line and line.strip().startswith('|')
    
    def count_code_block_lines(self, start_index):
        """Count lines in a code block starting at start_index."""
        count = 0
        for i in range(start_index + 1, len(self.lines)):
            if self.lines[i].strip().startswith('```'):
                break
            count += 1
        return count
    
    def should_add_pagebreak_before_heading(self, line):
        """Determine if we should add a page break before this heading."""
        # Always break before H1 (except first one)
        if self.is_heading(line, 1):
            return len(self.output) > 0
        
        # Break before H2 if we've accumulated enough content
        if self.is_heading(line, 2):
            return self.word_count_since_break > 800
        
        return False
    
    def add_pagebreak(self):
        """Add a page break marker."""
        # Don't add duplicate page breaks
        if self.output and self.output[-1].strip() == '<div class="page-break"></div>':
            return
        
        # Add some spacing
        if self.output and self.output[-1].strip():
            self.output.append('')
        
        self.output.append('<div class="page-break"></div>')
        self.output.append('')
        self.word_count_since_break = 0
    
    def process(self):
        """Process the markdown and insert page breaks."""
        i = 0
        while i < len(self.lines):
            line = self.lines[i]
            
            # Check for existing page breaks
            if '<div class="page-break"></div>' in line:
                self.output.append(line)
                self.word_count_since_break = 0
                i += 1
                continue
            
            # Check for headings
            if self.is_heading(line):
                if self.should_add_pagebreak_before_heading(line):
                    self.add_pagebreak()
                self.output.append(line)
                self.word_count_since_break += self.count_words(line)
                i += 1
                continue
            
            # Check for long code blocks
            if self.is_code_block_start(line):
                code_lines = self.count_code_block_lines(i)
                # Add page break before long code blocks
                if code_lines > 30 and self.word_count_since_break > 300:
                    self.add_pagebreak()
                
                # Add the code block
                self.output.append(line)
                i += 1
                while i < len(self.lines) and not self.lines[i].strip().startswith('```'):
                    self.output.append(self.lines[i])
                    i += 1
                if i < len(self.lines):
                    self.output.append(self.lines[i])  # closing ```
                i += 1
                continue
            
            # Regular content
            self.output.append(line)
            self.word_count_since_break += self.count_words(line)
            i += 1
        
        return '\n'.join(self.output)

def process_file(input_path, output_path=None):
    """Process a markdown file and add intelligent page breaks."""
    input_file = Path(input_path)
    
    if not input_file.exists():
        print(f"❌ Error: File not found: {input_path}")
        sys.exit(1)
    
    # Read input file
    print(f"📄 Reading: {input_path}")
    content = input_file.read_text(encoding='utf-8')
    
    # Process content
    print("🔍 Analyzing structure and inserting page breaks...")
    inserter = PageBreakInserter(content)
    processed = inserter.process()
    
    # Determine output path
    if output_path is None:
        output_path = input_path
        print(f"💾 Overwriting: {output_path}")
    else:
        print(f"💾 Writing to: {output_path}")
    
    # Write output
    Path(output_path).write_text(processed, encoding='utf-8')
    print("✅ Done!")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/auto-pagebreak.py input.md [output.md]")
        print("")
        print("Examples:")
        print("  python3 scripts/auto-pagebreak.py document.md")
        print("  python3 scripts/auto-pagebreak.py document.md document-processed.md")
        sys.exit(1)
    
    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else None
    
    try:
        process_file(input_path, output_path)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
