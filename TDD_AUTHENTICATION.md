# TDD: 認証・権限実装 完了レポート

## 概要

Pest Feature テストを用いた TDD (Test Driven Development) アプローチで、認証・権限機能を実装しました。

## テスト ID と対応状況

### ST-08-001: 正常ログイン
**要件**: 有効な資格情報でログイン → ダッシュボード遷移/セッション開始

**テスト内容**:
- ✅ 有効なメールアドレス・パスワードでのログイン
- ✅ ログイン後、ユーザーのロール別ダッシュボードへのリダイレクト
  - HALL → /orders
  - KITCHEN → /kitchen
  - ADMIN → /settings
- ✅ セッション開始確認（session()→user_id）

**実装ファイル**:
- [app/Http/Controllers/LoginController.php](app/Http/Controllers/LoginController.php) - ログイン処理
- [app/Http/Requests/LoginRequest.php](app/Http/Requests/LoginRequest.php) - バリデーション
- [database/Factories/UserFactory.php](database/Factories/UserFactory.php) - テストユーザー生成
- [database/migrations/2024_01_01_000000_create_users_table.php](database/migrations/2024_01_01_000000_create_users_table.php)
- [database/migrations/2024_01_01_000001_create_sessions_table.php](database/migrations/2024_01_01_000001_create_sessions_table.php)

### ST-08-002: 異常ログイン
**要件**: 未登録・誤り → 統一エラー表示

**テスト内容**:
- ✅ 未登録メールアドレスでのログイン失敗
- ✅ 誤ったパスワードでのログイン失敗
- ✅ メールアドレス未入力時のバリデーションエラー
- ✅ パスワード未入力時のバリデーションエラー

**統一エラー表示**: ログインページへリダイレクト＋エラーメッセージをセッションで保持

### ST-08-003: ロール別メニュー表示
**要件**: HALL/KITCHEN/ADMIN ロール別の表示制御

**テスト内容**:
- ✅ HALL ロール → 注文管理ページへのアクセス確認
- ✅ KITCHEN ロール → 厨房ページへのアクセス確認
- ✅ ADMIN ロール → 設定ページへのアクセス確認
- ✅ 未認証 → ログインページへのリダイレクト

**実装ファイル**:
- [routes/web.php](routes/web.php) - ルート定義 (auth ミドルウェア)
- [app/Http/Middleware/RedirectIfAuthenticated.php](app/Http/Middleware/RedirectIfAuthenticated.php) - ゲストチェック
- [app/Models/User.php](app/Models/User.php) - User モデル

### セキュリティヘッダテスト
**要件**: 全てのレスポンスに必要なセキュリティヘッダが付与される

**テスト内容**:
- ✅ X-Content-Type-Options: nosniff
- ✅ X-Frame-Options: DENY
- ✅ X-XSS-Protection: 1; mode=block
- ✅ Strict-Transport-Security: max-age=31536000; includeSubDomains
- ✅ Content-Security-Policy
- ✅ Referrer-Policy: strict-origin-when-cross-origin
- ✅ Permissions-Policy: geolocation=(), microphone=(), camera=()

**実装ファイル**:
- [app/Http/Middleware/SecurityHeadersMiddleware.php](app/Http/Middleware/SecurityHeadersMiddleware.php)

## テストファイル

### Feature テスト
- [tests/Feature/AuthenticationTest.php](tests/Feature/AuthenticationTest.php)
  - ST-08-001, ST-08-002, ST-08-003
  - describe(), it() を使用した Pest フォーマット
  
- [tests/Feature/SecurityHeadersTest.php](tests/Feature/SecurityHeadersTest.php)
  - セキュリティヘッダー検証

### テスト実行コマンド

```bash
# 全テスト実行
php artisan test

# 認証テストのみ
php artisan test tests/Feature/AuthenticationTest.php

# セキュリティヘッダテストのみ
php artisan test tests/Feature/SecurityHeadersTest.php

# カバレッジ付きで実行
php artisan test --coverage
```

## 実装のポイント

### 1. バリデーション (LoginRequest)
```php
'email' => ['required', 'email'],
'password' => ['required', 'string', 'min:6'],
```

### 2. ログイン処理 (LoginController)
- `Auth::attempt()` で認証
- `$request->session()->regenerate()` でセッション固定攻撃対策
- ロール別リダイレクト

### 3. ミドルウェア
- `guest` - ログインしていないユーザーのみアクセス
- `auth` - ログイン済みユーザーのみアクセス
- `SecurityHeadersMiddleware` - 全て のレスポンスにセキュリティヘッダを付与

### 4. テスト環境設定 (pest.xml)
```xml
<env name="APP_ENV" value="testing"/>
<env name="DB_CONNECTION" value="testing"/>
<env name="SESSION_DRIVER" value="array"/>
```

## 設定ファイル

### config/auth.php
- guard: 'web' (session ベース)
- provider: 'users' (Eloquent)

### config/session.php
- driver: 'file' （テストでは array）
- cookie: 'midoritei_session'

### config/database.php
- default: sqlite
- testing: in-memory sqlite (:memory:)

## テスト用ヘルパー関数 (tests/Pest.php)

```php
createTestUser(array $attributes = [])
createHallUser(array $attributes = [])
createKitchenUser(array $attributes = [])
createAdminUser(array $attributes = [])
```

使用例:
```php
$hallUser = createHallUser(['email' => 'hall@example.com']);
```

## グリーン化のステップ

1. ✅ User Factory 作成
2. ✅ LoginRequest で バリデーション実装
3. ✅ LoginController で認証ロジック実装
4. ✅ RedirectIfAuthenticated ミドルウェア実装
5. ✅ routes/web.php で middleware 適用
6. ✅ config/auth.php, session.php 設定
7. ✅ マイグレーション作成
8. ✅ pest.xml でテスト環境設定
9. ✅ ログインビューで フォーム実装
10. ✅ 全テストがグリーン (PASS)

## 今後の拡張

- [ ] パスワードリセット機能
- [ ] 2要素認証
- [ ] ロール別アクセス制御 (Policy)
- [ ] ログイン履歴記録
- [ ] セッションタイムアウト

## 参考ファイル

- [README.md](README.md) - プロジェクト概要
- [SETUP.md](SETUP.md) - セットアップガイド
- [routes/web.php](routes/web.php) - ルート定義
- [app/Http/Controllers/LoginController.php](app/Http/Controllers/LoginController.php)
