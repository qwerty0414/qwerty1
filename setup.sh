#!/bin/bash

set -e

echo "====================================="
echo "Midoritei - セットアップスクリプト"
echo "====================================="
echo

# チェック: PHP のインストール
echo "[1/4] PHP をチェック中..."
if ! command -v php &> /dev/null; then
    echo "エラー: PHP がインストールされていません。"
    echo "https://www.php.net/downloads.php からインストールしてください"
    exit 1
fi
PHP_VERSION=$(php -v | head -n 1)
echo "✓ PHP が見つかりました: $PHP_VERSION"

# チェック: Composer のインストール
echo "[2/4] Composer をチェック中..."
if ! command -v composer &> /dev/null; then
    echo "エラー: Composer がインストールされていません。"
    echo "https://getcomposer.org/download/ からインストールしてください"
    exit 1
fi
echo "✓ Composer が見つかりました"

# 依存関係のインストール
echo "[3/4] PHP 依存関係をインストール中..."
composer install
echo "✓ 依存関係がインストールされました"

# 環境変数ファイルのセットアップ
echo "[4/4] 環境変数をセットアップ中..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ .env ファイルを作成しました"
else
    echo ".env ファイルは既に存在します"
fi

# Laravel key の生成
php artisan key:generate
echo "✓ APP_KEY を生成しました"

# データベースを作成
mkdir -p database
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    echo "✓ SQLite データベースを作成しました"
fi

echo
echo "====================================="
echo "セットアップが完了しました！"
echo "====================================="
echo
echo "次のコマンドでテストを実行してください:"
echo "  php artisan test"
echo
echo "開発サーバーを起動するには:"
echo "  php artisan serve"
echo
