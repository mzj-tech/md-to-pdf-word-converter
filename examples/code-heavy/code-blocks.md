# AWS CLI コマンド例

## 概要

このドキュメントは、AWS CLIコマンドと自動改ページ機能のデモンストレーションです。

## EC2 インスタンス管理

以下は、EC2インスタンスを管理するためのAWS CLIコマンドです：

EC2インスタンスの一覧表示:
```bash
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId,InstanceType,State.Name,Tags[?Key==`Name`].Value|[0]]' \
  --output table
```

特定のインスタンスを起動:
```bash
aws ec2 start-instances --instance-ids i-1234567890abcdef0
```

特定のインスタンスを停止:
```bash
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
```

セキュリティグループの作成:
```bash
aws ec2 create-security-group \
  --group-name MySecurityGroup \
  --description "My security group" \
  --vpc-id vpc-1a2b3c4d
```

セキュリティグループにインバウンドルールを追加:
```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-903004f8 \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

## S3 バケット操作

S3バケットを操作するためのコマンド：

バケットの作成:
```bash
aws s3 mb s3://my-bucket-name --region ap-northeast-1
```

ファイルのアップロード:
```bash
aws s3 cp local-file.txt s3://my-bucket-name/
```

ファイルのダウンロード:
```bash
aws s3 cp s3://my-bucket-name/remote-file.txt ./
```

バケット内のファイル一覧:
```bash
aws s3 ls s3://my-bucket-name/ --recursive
```

ディレクトリの同期:
```bash
aws s3 sync ./local-folder s3://my-bucket-name/remote-folder/
```

バケットポリシーの設定:
```bash
aws s3api put-bucket-policy \
  --bucket my-bucket-name \
  --policy file://bucket-policy.json
```

## IAM ユーザー管理

IAMユーザーとポリシーの管理：

IAMユーザーの作成:
```bash
aws iam create-user --user-name new-user
```

ユーザーにポリシーをアタッチ:
```bash
aws iam attach-user-policy \
  --user-name new-user \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
```

アクセスキーの作成:
```bash
aws iam create-access-key --user-name new-user
```

ユーザーの一覧表示:
```bash
aws iam list-users --output table
```

ユーザーにアタッチされたポリシーの確認:
```bash
aws iam list-attached-user-policies --user-name new-user
```

## Lambda 関数管理

Lambda関数のデプロイと管理：

Lambda関数の作成:
```bash
aws lambda create-function \
  --function-name my-function \
  --runtime python3.9 \
  --role arn:aws:iam::123456789012:role/lambda-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip
```

Lambda関数の更新:
```bash
aws lambda update-function-code \
  --function-name my-function \
  --zip-file fileb://function.zip
```

Lambda関数の実行:
```bash
aws lambda invoke \
  --function-name my-function \
  --payload '{"key":"value"}' \
  response.json
```

Lambda関数の一覧表示:
```bash
aws lambda list-functions --output table
```

## CloudFormation スタック管理

CloudFormationスタックの作成と管理：

スタックの作成:
```bash
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=MyKey \
  --capabilities CAPABILITY_NAMED_IAM
```

スタックの更新:
```bash
aws cloudformation update-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=MyKey
```

スタックの削除:
```bash
aws cloudformation delete-stack --stack-name my-stack
```

スタックの状態確認:
```bash
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].StackStatus'
```

スタックイベントの表示:
```bash
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --max-items 10
```

## まとめ

これらのAWS CLIコマンドは、日常的なAWS運用タスクで使用される典型的な例です。コードブロックは自動的にプロフェッショナルなスタイルで表示され、ページ分割されずに保持されます。
