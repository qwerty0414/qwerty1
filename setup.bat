@echo off
setlocal enabledelayedexpansion

echo =====================================
echo Midoritei - セットアップスクリプト
echo =====================================
echo.

REM チェック: PHP のインストール
echo [1/4] PHP をチェック中...
php -v >nul 2>&1
if errorlevel 1 (
    echo エラー: PHP がインストールされていません。
    echo https://www.php.net/downloads.php からインストールしてください
    pause
    exit /b 1
)
echo ✓ PHP が見つかりました

REM チェック: Composer のインストール
echo [2/4] Composer をチェック中...
composer --version >nul 2>&1
if errorlevel 1 (
    echo エラー: Composer がインストールされていません。
    echo https://getcomposer.org/download/ からインストールしてください
    pause
    exit /b 1
)
echo ✓ Composer が見つかりました

REM 依存関係のインストール
echo [3/4] PHP 依存関係をインストール中...
call composer install
if errorlevel 1 (
    echo エラー: composer install に失敗しました
    pause
    exit /b 1
)
echo ✓ 依存関係がインストールされました

REM 環境変数ファイルのセットアップ
echo [4/4] 環境変数をセットアップ中...
if not exist .env (
    copy .env.example .env
    echo ✓ .env ファイルを作成しました
) else (
    echo .env ファイルは既に存在します
)

REM Laravel key の生成
php artisan key:generate
if errorlevel 1 (
    echo エラー: php artisan key:generate に失敗しました
    pause
    exit /b 1
)
echo ✓ APP_KEY を生成しました

REM データベースに作成
if not exist database\database.sqlite (
    type nul > database\database.sqlite
    echo ✓ SQLite データベースを作成しました
)

echo.
echo =====================================
echo セットアップが完了しました！
echo =====================================
echo.
echo 次のコマンドでテストを実行してください:
echo   php artisan test
echo.
echo 開発サーバーを起動するには:
echo   php artisan serve
echo.
pause
