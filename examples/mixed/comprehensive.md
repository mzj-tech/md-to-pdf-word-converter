# 総合デモンストレーション

## 1. プロジェクト概要

このドキュメントは、Markdown変換ツールのすべての機能を示す総合的な例です。

### 1.1 目的

- 様々なMarkdown要素の表示確認
- 自動改ページ機能のテスト
- PDF/Word出力の品質確認

## 2. 機能比較表

| 機能 | PDF | Word | 備考 |
|------|-----|------|------|
| 見出し | ✅ | ✅ | H1-H6対応 |
| テーブル | ✅ | ✅ | 罫線・網掛け自動 |
| コードブロック | ✅ | ✅ | シンタックスハイライト |
| 自動改ページ | ✅ | ✅ | 20行以上のコードで自動 |
| 日本語フォント | ✅ | ✅ | 游ゴシック等 |

## 3. インストール手順

### 3.1 前提条件

以下のツールが必要です：

```bash
# Node.js のインストール確認
node --version

# Pandoc のインストール確認
pandoc --version

# Python のインストール確認
python3 --version
```

### 3.2 ツールのインストール

```bash
# md-to-pdf のインストール
npm install -g md-to-pdf

# Pandoc のインストール (macOS)
brew install pandoc

# python-docx のインストール
pip3 install python-docx
```

## 4. 使用例

### 4.1 単一ファイルの変換

**PDFに変換:**
```bash
./file_conversion_tool/scripts/convert-with-pagebreak.sh document.md
```

**Wordに変換:**
```bash
./file_conversion_tool/scripts/convert-single-word.sh document.md
```

### 4.2 一括変換

```bash
# PDF一括変換
./file_conversion_tool/scripts/convert-to-pdf.sh docs/ output/pdf/

# Word一括変換
./file_conversion_tool/scripts/convert-to-word.sh docs/ output/docx/
```

## 5. 設定オプション

### 5.1 自動改ページの無効化

```bash
# PDF
./file_conversion_tool/scripts/convert-with-pagebreak.sh document.md --no-auto-pagebreak

# Word
./file_conversion_tool/scripts/convert-single-word.sh document.md --no-auto-pagebreak
```

### 5.2 手動改ページの挿入

Markdown内に以下を追加：

```html
<div class="page-break"></div>
```

## 6. トラブルシューティング

### 6.1 よくある問題

> **問題**: 日本語が文字化けする
> 
> **解決策**: UTF-8エンコーディングでMarkdownファイルを保存してください。

> **問題**: コードブロックがページをまたいで分割される
> 
> **解決策**: 自動改ページ機能が有効になっているか確認してください。

## 7. まとめ

このツールを使用することで、Markdownから高品質なPDF/Word文書を簡単に生成できます。
