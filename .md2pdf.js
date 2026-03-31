module.exports = {
  pdf_options: {
    format: "A4",
    displayHeaderFooter: true,
    headerTemplate: "<div></div>",
    footerTemplate:
      '<div style="width: 100%; font-size: 9px; text-align: center; color: #999; padding: 0 20mm;"><span class="pageNumber"></span> / <span class="totalPages"></span></div>',
    margin: {
      top: "20mm",
      bottom: "20mm",
      left: "18mm",
      right: "18mm",
    },
  },
  stylesheet: [],
  css: `
    /* ===== Base ===== */
    body {
      font-family: "Hiragino Kaku Gothic ProN", "Noto Sans JP", "Noto Sans CJK JP", "Yu Gothic", "Meiryo", sans-serif;
      font-size: 10.5pt;
      line-height: 1.8;
      letter-spacing: 0.02em;
      color: #333;
    }

    /* ===== Headings ===== */
    h1 {
      font-size: 1.6em;
      margin: 0 0 0.6em;
      padding-bottom: 0.3em;
      border-bottom: 2px solid #2c3e50;
      line-height: 1.4;
    }
    h2 {
      font-size: 1.3em;
      margin: 1.2em 0 0.5em;
      padding-bottom: 0.2em;
      border-bottom: 1px solid #ddd;
      line-height: 1.4;
    }

    /* MD 内で <div class="page-break"></div> を挿入して改ページ */
    .page-break {
      page-break-before: always;
      margin: 0;
      padding: 0;
    }
    h3 {
      font-size: 1.1em;
      margin: 1em 0 0.4em;
      line-height: 1.4;
    }

    /* ===== Paragraphs & Lists ===== */
    p {
      margin: 0.5em 0;
      orphans: 3;
      widows: 3;
    }
    ul, ol {
      margin: 0.5em 0;
      padding-left: 1.5em;
    }
    li {
      margin: 0.25em 0;
    }

    /* ===== Tables ===== */
    table {
      border-collapse: collapse;
      width: 100%;
      font-size: 0.88em;
      margin: 0.8em 0;
      page-break-inside: avoid;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 6px 10px;
      text-align: left;
    }
    th {
      background-color: #f0f4f8;
      font-weight: bold;
    }
    tr:nth-child(even) {
      background-color: #fafbfc;
    }

    /* ===== Code ===== */
    code {
      font-size: 0.88em;
      background-color: #f5f5f5;
      padding: 0.15em 0.3em;
      border-radius: 3px;
    }
    pre {
      font-size: 0.82em;
      background-color: #f8f8f8;
      border: 1px solid #e0e0e0;
      border-radius: 4px;
      padding: 12px 14px;
      line-height: 1.5;
      page-break-inside: avoid;
      overflow-x: auto;
    }
    pre code {
      background: none;
      padding: 0;
    }

    /* ===== Blockquote ===== */
    blockquote {
      margin: 0.6em 0;
      padding: 0.4em 1em;
      border-left: 3px solid #3498db;
      background-color: #f7f9fc;
      color: #555;
      font-size: 0.95em;
      page-break-inside: avoid;
    }

    /* ===== Horizontal Rule ===== */
    hr {
      border: none;
      border-top: 1px solid #ddd;
      margin: 1.5em 0;
    }

    /* ===== Page Break Control ===== */
    h1, h2, h3 {
      page-break-after: avoid;
    }
    table, pre, blockquote {
      page-break-inside: avoid;
    }
  `,
};
