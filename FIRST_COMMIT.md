# Initial Commit Information

## Commit Message
```
chore: bootstrap Laravel with Pest and base scaffolding
```

## Changes Included

このプロジェクトの初回コミットに含まれるファイル構造：

### コア ファイル
- `composer.json` - Laravel と Pest 依存関係
- `.env.example` - 環境変数テンプレート
- `.gitignore` - Git 除外設定
- `README.md` - プロジェクトドキュメント
- `SETUP.md` - セットアップガイド

### アプリケーション構造
- `app/Models/User.php` - ユーザー モデル（HALL, KITCHEN, ADMIN ロール）
- `app/Enums/BillStatus.php` - 請求ステータス Enum
- `app/Http/Responses/ApiResponse.php` - 統一 API レスポンス
- `app/Http/Middleware/SecurityHeadersMiddleware.php` - セキュリティヘッダ
- `app/Http/Controllers/` - 5つのメインコントローラー
  - `LoginController`
  - `OrdersController`
  - `KitchenController`
  - `SeatsController`
  - `SettingsController`

### ルート・ビュー
- `routes/web.php` - ウェブ ルート定義
- `routes/console.php` - Artisan コマンド
- `resources/views/` - Blade テンプレート
  - `welcome.blade.php` - ホーム
  - `auth/login.blade.php` - ログイン
  - `orders/index.blade.php` - 注文管理
  - `kitchen/index.blade.php` - 厨房
  - `seats/index.blade.php` - 座席管理
  - `settings/index.blade.php` - 設定

### テスト
- `tests/Pest.php` - Pest テスト設定
- `tests/TestCase.php` - テス ベースクラス
- `tests/Feature/PageTest.php` - ページ機能テスト
- `tests/Unit/Enums/BillStatusTest.php` - Enum ユニットテスト

### 設定・ユーティリティ
- `bootstrap/app.php` - Laravel アプリケーション初期化
- `public/index.php` - アプリケーション エントリポイント
- `artisan` - Artisan CLI
- `pest.xml` - Pest テスト設定
- `package.json` - Node.js 依存関係
- `setup.bat` - Windows セットアップスクリプト
- `setup.sh` - Unix/Mac セットアップスクリプト

## セットアップ後のコミット手順

```bash
git init
git config user.name "Your Name"
git config user.email "your.email@example.com"
git add .
git commit -m "chore: bootstrap Laravel with Pest and base scaffolding"
git log --oneline
```

## 環境

- PHP: 8.2+
- Laravel: 11.0
- Pest: 3.0+
- Composer: 2.0+

---
このファイルは参考用です。実際のコミットは、開発環境で Git を使用して実行してください。
