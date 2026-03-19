# Midoritei - セットアップガイド

このプロジェクトを実行するには、以下のツールをインストールする必要があります。

## 必須ツール

### 1. PHP 8.2 以上

#### Windows
- **PHP バイナリー**: https://windows.php.net/download/ から VC Redist 版をダウンロード
- または **Laravel Herd**: https://herd.laravel.com/ で一括インストール（推奨）

#### macOS
```bash
brew install php
```

#### Linux (Ubuntu)
```bash
sudo apt-get update
sudo apt-get install php php-cli php-sqlite3
```

### 2. Composer

https://getcomposer.org/download/ からインストール

#### Windows での確認
```powershell
composer --version
```

#### macOS/Linux での確認
```bash
composer --version
```

### 3. Git（オプション だが推奨）

- Windows: https://git-scm.com/download/win
- macOS: `brew install git`
- Linux: `sudo apt-get install git`

## セットアップ手順

### 自動セットアップ（Windows）

```powershell
cd path\to\midoritei
.\setup.bat
```

### 自動セットアップ（macOS/Linux）

```bash
cd path/to/midoritei
chmod +x setup.sh
./setup.sh
```

### 手動セットアップ

1. **依存関係のインストール**
   ```bash
   composer install
   ```

2. **環境ファイルの設定**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

3. **データベースの作成**
   ```bash
   touch database/database.sqlite
   ```

4. **Node 依存関係のインストール（オプション）**
   ```bash
   npm install
   ```

## 開発サーバーの起動

```bash
php artisan serve
```

ブラウザで http://localhost:8000 にアクセスしてください

## テストの実行

```bash
php artisan test
```

## 初回 Git コミット

ツールをインストール後、以下のコマンドで初回コミットを実行してください：

```bash
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
git add .
git commit -m "chore: bootstrap Laravel with Pest and base scaffolding"
```

## 環境変数の主要設定

`.env` ファイル内の重要な設定：

- `APP_NAME=Midoritei` - アプリケーション名
- `APP_KEY=` - Laravel の暗号化キー（`php artisan key:generate` で自動生成）
- `DB_DATABASE=database/database.sqlite` - SQLite データベース
- `LO_MINUTES_BEFORE_CLOSE=30` - ラストオーダー時間
- `CALL_COOLDOWN_SECONDS=30` - コール機能のクールダウン

## トラブルシューティング

### "php: command not found" エラー
- PHP がインストールされていません
- PATH に PHP ディレクトリを追加してください

### "composer: command not found" エラー
- Composer がインストールされていません
- https://getcomposer.org/download/ を参照してください

### "database/database.sqlite" エラー
```bash
touch database/database.sqlite
php artisan migrate
```

### ポート 8000 が既に使用中
```bash
php artisan serve --port=8001
```

## 次のステップ

1. README.md を読んでシステム概要を理解する
2. `routes/web.php` でルート定義を確認
3. `app/Enums/BillStatus.php` で Enum の実装を確認
4. テストを実行: `php artisan test`

## サポート

質問や問題がある場合は、README.md を参照するか、Issue を作成してください。
