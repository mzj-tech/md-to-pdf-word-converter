# Markdown から PDF/Word への変換ツール

**プロフェッショナルな文書生成のためのツール非依存ソリューション**

MarkdownファイルをプロフェッショナルにフォーマットされたPDFおよびWord文書に変換します。任意のAIアシスタント(Kiro、Claude、Cursor)またはコマンドラインで動作します。

## 🎯 機能

- プロフェッショナルなフォーマット(ヘッダー、フッター、ページ番号、スタイル付きテーブル)
- 日本語および多言語コンテンツのサポート
- 複数ファイルの一括処理
- プロフェッショナルなテーブル罫線と交互の行の網掛け
- グレーボックス内のコードブロック
- 公共セクター対応のフォーマット
- 任意のAIツールまたは手動での動作

## 📦 プロジェクトでこのツールを使用する
プロジェクトディレクトリで以下のコマンドを実行してください

```bash
curl -sSL https://raw.githubusercontent.com/mzj-tech/md-to-pdf-word-converter/main/install.sh | bash
```

これにより:
- ✅ 必要なすべてのファイルを `file_conversion_tool/` フォルダにダウンロード
- ✅ 依存関係をチェック
- ✅ python-docxを自動的にインストール
- ✅ スクリプトを実行可能にする

## 🛠️ インストール
### 前提条件
**PDF生成の場合:**
```bash
# md-to-pdfをインストール
npm install -g md-to-pdf
```

**Word生成の場合:**
```bash
# Pandocをインストール
brew install pandoc

# Python 3をインストール
brew install python3 

# プロフェッショナルなスタイリングのためにpython-docxをインストール
pip3 install python-docx
```

## 🚀 ファイルを変換する
### 単一ファイルの変換

**PDFに変換:**
```bash
npx md-to-pdf --config-file file_conversion_tool/.md2pdf.js folder/file_name.md
```

**Wordに変換:**
```bash
./file_conversion_tool/scripts/convert-single-word.sh folder/file_name.md folder/file.docx
```

### 一括変換

**ディレクトリ内のすべてのファイルを変換:**
```bash
# PDF
./file_conversion_tool/scripts/convert-to-pdf.sh folder/ output/pdf/

# Word
./file_conversion_tool/scripts/convert-to-word.sh folder/ output/docx/
```

## 🎨 カスタマイズ
### PDFスタイリング

`.md2pdf.js` を編集して、フォント、色、余白、またはテーブルスタイルを変更します。

**カスタマイズの例:**
```javascript
// テーブルのフォントサイズを変更
table {
  font-size: 9pt;  // 10ptから縮小
}

// ページの余白を変更
pdf_options: {
  margin: { top: '30mm', bottom: '30mm', left: '25mm', right: '25mm' }
}
```

### Wordスタイリング

Word文書は `scripts/style-docx.py` を介して自動的にプロフェッショナルなスタイリングが適用されます:
- ✅ 罫線と交互の行の網掛けを持つテーブル
- ✅ グレーボックス内のコードブロック(PDFと同様)
- ✅ プロフェッショナルな見出しスタイル

スタイリングスクリプトは以下を適用します:
- **テーブル罫線**: ヘッダー行の網掛け(ライトグレー D9D9D9)と交互の行の色(F2F2F2)を持つ黒い罫線
- **コードブロックの背景**: コードブロック周辺のグレーボックス(E8E8E8)(Pandocの「Source Code」スタイルを検出)
- **プロフェッショナルな間隔**: 適切なインデントとパディング

**Wordスタイリングをカスタマイズするには**、`scripts/style-docx.py` を編集してください:
```python
# テーブルヘッダーの色を変更
shading.set(qn('w:fill'), 'D9D9D9')  # ライトグレー - この16進コードを変更

# コードブロックの背景を変更
shading.set(qn('w:fill'), 'E8E8E8')  # ライトグレー - この16進コードを変更

# コードブロックのフォントを変更
run.font.name = 'Courier New'  # 任意の等幅フォントに変更
run.font.size = Pt(9)  # サイズを変更
```

### PDFでの改ページ

Markdown内に改ページを追加して、不自然な分割を防ぎます:

```html
<div class="page-break"></div>
```

**使用例:**
```markdown
## セクション1

セクション1のコンテンツ...

<div class="page-break"></div>

## セクション2

セクション2のコンテンツは新しいページから始まります...
```

これにより、セクションがまとまって保たれ、ページをまたいで分割されません。

## 🌐 言語サポート
このツールは日本語および多言語コンテンツを完全にサポートしています:
- 日本語文字はPDFとWordの両方で正しくレンダリングされます
- 特別な設定は不要です
- UTF-8エンコードされた任意のMarkdownファイルで動作します

## 🤖 AIアシスタント統合

Kiro、Claude Code、Cursorなどの任意のAIアシスタントとシームレスに動作します。

単に尋ねてください: 「folder/file.mdをPDFに変換して」または「すべてのMarkdownファイルをWordに変換して」

---
**バージョン**: 1.0.0  
**最終更新**: 2026-03-31
