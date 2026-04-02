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
- 自動インテリジェント改ページ機能

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

## 📚 サンプル・テストデータ

`examples/` ディレクトリには、様々なMarkdownパターンとその変換結果（PDF/Word）が含まれています：

- `basic/` - 基本的なMarkdown要素
- `tables/` - テーブル表示例
- `code-heavy/` - 長いコードブロック例
- `mixed/` - 総合的な例

詳細は [examples/README.md](examples/README.md) を参照してください。

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
./file_conversion_tool/scripts/convert-with-pagebreak.sh folder/file_name.md
```

**Wordに変換:**
```bash
./file_conversion_tool/scripts/convert-single-word.sh folder/file_name.md
```

両方とも、元の.mdファイルと同じフォルダにPDF/Wordファイルが生成されます。

自動改ページを無効にする場合:
```bash
# PDF
./file_conversion_tool/scripts/convert-with-pagebreak.sh folder/file_name.md --no-auto-pagebreak

# Word
./file_conversion_tool/scripts/convert-single-word.sh folder/file_name.md --no-auto-pagebreak
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

PDF/Wordのスタイルをカスタマイズしたい場合は、Kiro/Claude Codeに直接依頼できます:

**カスタマイズ例:**
- 「PDFのテキストを大きくして」
- 「Wordのページ余白を30mmに増やして」
- 「テーブルの背景色を変更して」
- 「コードブロックのフォントをConsolasに変更して」

AIアシスタントが自動的に設定ファイルを編集します！

### PDFでの改ページ

**自動インテリジェント改ページ (デフォルトで有効!):**

このツールは、デフォルトで自動的に最適な位置に改ページを挿入します。特別な設定は不要です！

自動改ページのルール:
- ✅ H1見出しの前(最初のものを除く)
- ✅ 長いコンテンツ(800語以上)の後のH2見出しの前
- ✅ 中程度のコードブロック(20-40行)が続くH2見出しの前
- ✅ 中程度のコードブロック(30-50行)の前
- ✅ 既存の手動改ページを保持
- ✅ コードブロックは見出しと一緒に保持されます

**ベストプラクティス:** 複数のコマンドを含むドキュメントでは、1つの大きなブロックではなく、各コマンドごとに小さなコードブロックを使用してください。これにより、ページレイアウトが改善され、説明とコマンドが一緒に保持されます。

**手動改ページ:**

より細かい制御が必要な場合は、Markdown内に手動で改ページを追加できます:

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

手動改ページは自動改ページと併用でき、より細かい制御が可能です。

**注意:** Wordでは、非常に長いコードブロック(1ページに収まらない場合)は自動的に分割される場合があります。これはWordの制限です。重要なコードブロックの前に手動で改ページを追加することで、より細かく制御できます。

## 🪝 自動変換フック設定 (Kiroユーザー向け)

Kiroを使用している場合、保存時に自動変換フックが利用可能です。デフォルトでは、`docs/`フォルダ内の.mdファイルのみが自動変換されます。

**フックパターンをカスタマイズする:**

`.kiro/hooks/auto-convert-pdf.kiro.hook`および`.kiro/hooks/auto-convert-word.kiro.hook`を編集して、どのファイルを自動変換するかを指定できます:

```json
{
  "when": {
    "type": "fileEdited",
    "patterns": [
      "docs/*.md",
      "reports/*.md"
    ]
  }
}
```

**パターン例:**
- `"docs/*.md"` - docsフォルダ内のすべての.mdファイル
- `"*.md"` - プロジェクト内のすべての.mdファイル
- `"specific-file.md"` - 特定のファイルのみ
- `"folder1/*.md", "folder2/*.md"` - 複数のフォルダ

**フックを無効にする:**

自動変換が不要な場合は、フックファイルで`"enabled": false`に設定してください。

## 🤖 AIアシスタント統合

Kiro、Claude Code、Cursorなどの任意のAIアシスタントとシームレスに動作します。

単に尋ねてください: 「folder/file.mdをPDFに変換して」または「すべてのMarkdownファイルをWordに変換して」

---
**バージョン**: 1.0.0  
**最終更新**: 2026-04-02
