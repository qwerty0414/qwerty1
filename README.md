# Midoritei - Restaurant Management System

レストラン管理システム「みどり亭」の Laravel ベースの実装です。

## システム概要

Midoritei は、レストランの注文管理、厨房管理、座席管理を効率化するためのシステムです。

- **ホール機能**: 注文・座席管理
- **厨房機能**: 注文確認・調理進捗管理
- **管理機能**: ユーザー・設定管理

## ユーザーロール

- **HALL**: ホール従業員（注文・座席管理）
- **KITCHEN**: 厨房スタッフ（注文確認・調理）
- **ADMIN**: 管理者（全権限）

## 環境変数

主要な環境変数は `.env.example` を参照してください。

### カスタム設定

- `LO_MINUTES_BEFORE_CLOSE`: 営業終了前の ラストオーダー 何分前か（デフォルト: 30分）
- `CALL_COOLDOWN_SECONDS`: コール機能のクールダウン秒数（デフォルト: 30秒）

## セットアップ手順

### 前提条件

- PHP 8.2 以上
- Composer
- Node.js 18+ (オプション、フロントエンド資産用)

### インストール

1. **プロジェクトをクローン**
   ```bash
   cd /path/to/midoritei
   ```

2. **依存関係のインストール**
   ```bash
   composer install
   ```

3. **環境ファイルの設定**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **データベースの初期化**
   ```bash
   touch database/database.sqlite
   php artisan migrate
   php artisan seed:run
   ```

5. **開発サーバーの起動**
   ```bash
   php artisan serve
   ```

   サーバーは `http://localhost:8000` で起動します。

## テスト実行

このプロジェクトは **Pest** をテストフレームワークとして使用しています。

### 全テスト実行
```bash
php artisan test
```

### 特定のテストスイーに実行
```bash
php artisan test tests/Unit
php artisan test tests/Feature
```

### カバレッジ付きでテスト実行
```bash
php artisan test --coverage
```

### 単一のテストファイルを実行
```bash
php artisan test tests/Feature/PageTest.php
```

## ディレクトリ構造

```
midoritei/
├── app/
│   ├── Enums/              # Enum 定義（BillStatus など）
│   ├── Http/
│   │   ├── Controllers/    # コントローラ
│   │   ├── Middleware/     # ミドルウェア（セキュリティヘッダなど）
│   │   └── Responses/      # 共通レスポンス
│   ├── Models/             # Eloquent モデル
│   └── Providers/          # サービスプロバイダ
├── resources/
│   └── views/              # Blade テンプレート
├── routes/
│   └── web.php             # ウェブルート定義
├── tests/
│   ├── Feature/            # 機能テスト
│   ├── Unit/               # ユニットテスト
│   └── Pest.php            # Pest 設定
├── database/
│   ├── migrations/         # マイグレーション
│   └── seeders/            # シーダー
├── .env.example            # 環境変数テンプレート
├── composer.json           # PHP依存関係
└── README.md               # このファイル
```

## 主要ページ

- `/` - ホーム（ウェルカムページ）
- `/login` - ログイン
- `/orders` - 注文管理
- `/kitchen` - 厨房
- `/seats` - 座席管理
- `/settings` - 設定

## 主要コンポーネント

### Enum: BillStatus
請求ステータスの定義
- `PENDING`: 未払い
- `PAID`: 支払済
- `CANCELLED`: キャンセル

### ApiResponse
API レスポンスの統一形式
```php
ApiResponse::success($data, 'メッセージ');
ApiResponse::error('エラーメッセージ', $data);
ApiResponse::created($data);
ApiResponse::notFound();
```

### Middleware: SecurityHeadersMiddleware
セキュリティヘッダを自動付与
- X-Content-Type-Options
- X-Frame-Options
- X-XSS-Protection
- Strict-Transport-Security
- Content-Security-Policy
- Referrer-Policy
- Permissions-Policy

## 開発ガイド

### 新しいマイグレーションの作成
```bash
php artisan make:migration create_orders_table
```

### モデルの生成
```bash
php artisan make:model Order -m
```

### コントローラの生成
```bash
php artisan make:controller OrdersController
```

## ライセンス

MIT

## 貢献

バグ報告や機能リクエストは Issue を作成してください。

## サポート

質問や問題がある場合は、Issue トラッカーを利用してください。
