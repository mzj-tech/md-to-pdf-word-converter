# サンプル・テストデータ

このディレクトリには、様々なMarkdownパターンとその変換結果（PDF/Word）が含まれています。

## 📁 ディレクトリ構成

### basic/
基本的なMarkdown要素のサンプル
- `simple-document.md` - 見出し、段落、リスト、コードブロック、引用の基本例
- `simple-document.pdf` - PDF変換結果
- `simple-document.docx` - Word変換結果

### tables/
テーブル表示のサンプル
- `table-example.md` - 様々なテーブルパターン
- `table-example.pdf` - PDF変換結果（罫線・網掛け自動適用）
- `table-example.docx` - Word変換結果（罫線・網掛け自動適用）

### code-heavy/
長いコードブロックのサンプル
- `code-blocks.md` - 複数のAWS CLIコマンド例（EC2, S3, IAM, Lambda, CloudFormation）
- `code-blocks.pdf` - PDF変換結果（自動改ページ適用）
- `code-blocks.docx` - Word変換結果（自動改ページ適用）

### mixed/
総合的なサンプル
- `comprehensive.md` - すべての要素を含む総合例
- `comprehensive.pdf` - PDF変換結果
- `comprehensive.docx` - Word変換結果

## 🎯 各サンプルの目的

| サンプル | テスト内容 |
|---------|-----------|
| basic | 基本的なMarkdown要素の表示確認 |
| tables | テーブルの罫線・網掛けスタイリング確認 |
| code-heavy | 長いコードブロックの自動改ページ確認 |
| mixed | すべての機能の総合的な動作確認 |

## 🔄 サンプルの再生成方法

すべてのサンプルを再生成する場合：

```bash
# examples ディレクトリから実行
for dir in */; do
  for md in "$dir"*.md; do
    [ "$md" = "*/README.md" ] && continue
    ../scripts/convert-with-pagebreak.sh "$md"
    ../scripts/convert-single-word.sh "$md"
  done
done
```

個別に再生成する場合：

```bash
# PDF
../scripts/convert-with-pagebreak.sh basic/simple-document.md

# Word
../scripts/convert-single-word.sh basic/simple-document.md
```

## 📝 注意事項

- すべてのサンプルは自動改ページ機能が有効な状態で生成されています
- PDF/Wordファイルはリポジトリに含まれており、ツールの動作確認に使用できます
- 新しいパターンを追加する場合は、適切なディレクトリに配置してください

## ✅ 期待される動作

### PDF変換
- 日本語フォントが正しく表示される
- テーブルに罫線と網掛けが適用される
- コードブロックが灰色の背景で表示される
- 長いコードブロック（20行以上）の前に自動改ページが挿入される
- ページ番号がフッターに表示される

### Word変換
- 日本語フォントが正しく表示される
- テーブルに罫線と網掛けが適用される
- コードブロックが灰色の背景で表示される
- 長いコードブロックが可能な限りページ分割されない
- 見出しが次のコンテンツと一緒に保持される
