# TDD: 注文管理（ST-09）実装レポート

## 概要

Pest Feature テストを用いた TDD アプローチで、注文管理（スタッフ）機能を実装しました。

## テスト ID と対応状況

### ST-09-001: 新着注文が数秒内で一覧に反映

**要件**: 席/時刻/カテゴリと共に新着注文が一覧に表示される

**テスト内容**:
- ✅ 新着注文が席・時刻・カテゴリと共に一覧に表示
- ✅ 複数の新着注文がカテゴリごとに分類
- ✅ 注文作成から一覧表示までの遅延が 3秒以内
- ✅ 席番号と時刻が正確に反映

**実装ファイル**:
- [app/Http/Controllers/Api/OrderController.php](app/Http/Controllers/Api/OrderController.php) - index(), show()
- [app/Models/Order.php](app/Models/Order.php)
- [database/factories/OrderFactory.php](database/factories/OrderFactory.php)
- [database/migrations/2024_01_02_000000_create_orders_table.php](database/migrations/2024_01_02_000000_create_orders_table.php)

**API エンドポイント**:
- `GET /api/orders` - 注文一覧
- `GET /api/orders/{id}` - 特定の注文詳細

### ST-09-002: 編集/削除 → 履歴・顧客UI に矛盾なく反映

**要件**: 注文の編集・削除時に履歴が記録され、顧客UI に影響しない

**テスト内容**:
- ✅ 注文を編集 → 履歴が記録
- ✅ 注文アイテムを削除 → 親注文の整合性を保つ
- ✅ 注文削除 → 管理画面のみ反映（顧客UI に影響しない）
- ✅ 削除履歴が記録される

**実装ファイル**:
- [app/Http/Controllers/Api/OrderController.php](app/Http/Controllers/Api/OrderController.php) - update(), destroy()
- [app/Http/Controllers/Api/OrderItemController.php](app/Http/Controllers/Api/OrderItemController.php) - destroy()
- [app/Models/Order.php](app/Models/Order.php) - logHistory(), SoftDeletes
- [app/Models/OrderHistory.php](app/Models/OrderHistory.php)

**API エンドポイント**:
- `PATCH /api/orders/{id}` - 注文編集
- `DELETE /api/orders/{id}` - 注文削除（ソフト削除）
- `DELETE /api/order-items/{id}` - アイテム削除

### ST-09-003: 提供管理（offerQty で完了判定）

**要件**: 提供数（offer_qty）を更新し、完全提供時に注文ステータスが自動更新

**テスト内容**:
- ✅ 提供数（offer_qty）を更新 → 注文完了判定が正確
- ✅ 全アイテムが提供完了 → 注文ステータスが「completed」に自動更新
- ✅ 提供数が注文数を超えないようバリデーション
- ✅ 残り数量（remaining_qty）が在庫と一貫性を保つ

**実装ファイル**:
- [app/Http/Controllers/Api/OrderItemController.php](app/Http/Controllers/Api/OrderItemController.php) - update()
- [app/Models/OrderItem.php](app/Models/OrderItem.php) - updateOfferQty()
- [app/Models/Order.php](app/Models/Order.php) - markAsCompleted()

**API エンドポイント**:
- `PATCH /api/order-items/{id}` - 提供数更新

### ST-03-005: 在庫/売切れ表示反映（≤ 3秒）

**要件**: 在庫状態がUI に 3秒以内に反映

**テスト内容**:
- ✅ 在庫が不足 → UI に売切れ表示（3秒以内）
- ✅ 在庫が十分 → UI に在庫ありを表示（3秒以内）
- ✅ 提供により在庫更新 → 新しい在庫状態が 3秒以内に反映

**実装ファイル**:
- [app/Http/Controllers/Api/OrderItemController.php](app/Http/Controllers/Api/OrderItemController.php) - show()
- [app/Models/OrderItem.php](app/Models/OrderItem.php) - is_sold_out, available_qty

**API エンドポイント**:
- `GET /api/order-items/{id}` - アイテム詳細（在庫状態含む）

## テストファイル

- [tests/Feature/OrderManagementTest.php](tests/Feature/OrderManagementTest.php)
  - ST-09-001, 002, 003, ST-03-005 全テスト
  - Pest describe(), it() フォーマット

## テスト実行コマンド

```bash
# 全テスト実行
php artisan test

# 注文管理テストのみ
php artisan test tests/Feature/OrderManagementTest.php

# 特定の describe ブロックのみ
php artisan test tests/Feature/OrderManagementTest.php -p "ST-09-001"
```

## 実装のポイント

### 1. モデル設計

**Order**:
- seat, status, notes
- SoftDeletes (ソフト削除)
- items() HasMany relationship
- logHistory() - 履歴記録
- isFullyOffered() - 完全提供判定
- markAsCompleted() - ステータス自動更新

**OrderItem**:
- product_id, category, qty, offer_qty
- stock - 在庫数
- remaining_qty (Computed) - qty - offer_qty
- is_sold_out (Computed) - stock <= 0
- available_qty (Computed) - min(stock, remaining)
- updateOfferQty() - 提供数更新 + 在庫減少

**OrderHistory**:
- order_id, action, details
- 全ての注文編集・削除をログ記録

### 2. バリデーション

```php
// OrderItemController
'offer_qty' => 'required|integer|min:0|max:' . $orderItem->qty
```

### 3. パフォーマンス

- インデックス: seat, status, created_at, category
- Query optimization: with('items') で N+1 回避
- In-memory DB: テスト実行時は :memory: sqlite

### 4. ソフト削除と履歴

```php
// Order はソフト削除だが、管理画面では削除済みを非表示
$orders = Order::with('items')
    ->orderByDesc('created_at')
    ->get();  // デフォルトではソフト削除済みはクエリから除外

// 履歴は削除されない
$order->logHistory('deleted', 'Order soft-deleted');
```

## データベース構造

### orders テーブル
```sql
- id (PK)
- seat (INDEX)
- status (ENUM: pending, preparing, completed, cancelled, INDEX)
- notes (TEXT)
- created_at (INDEX)
- updated_at
- deleted_at (SoftDeletes)
```

### order_items テーブル
```sql
- id (PK)
- order_id (FK → orders)
- product_id
- category (INDEX)
- qty (INT)
- offer_qty (INT)
- stock (INT)
- price (DECIMAL)
- created_at
- updated_at
- INDEX: (order_id, category)
```

### order_history テーブル
```sql
- id (PK)
- order_id (FK → orders)
- action (INDEX)
- details (TEXT)
- created_at
- INDEX: (order_id, action)
```

## Factory 設計

- OrderFactory: 3つの状態メソッド (pending, preparing, completed)
- OrderItemFactory: category, stock レベル指定メソッド
- OrderHistoryFactory: アクション記録

## API レスポンス

### 注文一覧
```json
{
  "success": true,
  "message": "Orders retrieved successfully",
  "data": [
    {
      "id": 1,
      "seat": "A-01",
      "status": "pending",
      "created_at": "2024-01-02T10:30:00Z",
      "items": [
        {
          "id": 1,
          "category": "food",
          "qty": 3,
          "offer_qty": 0,
          "remaining_qty": 3,
          "stock": 15,
          "is_sold_out": false
        }
      ]
    }
  ]
}
```

### アイテム詳細（在庫状態含む）
```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_id": 1,
    "category": "food",
    "qty": 3,
    "offer_qty": 0,
    "remaining_qty": 3,
    "stock": 15,
    "available_qty": 3,
    "is_sold_out": false,
    "price": "1500.00"
  }
}
```

## グリーン化のステップ

1. ✅ Model 作成 (Order, OrderItem, OrderHistory)
2. ✅ Migration 作成
3. ✅ Factory 作成
4. ✅ API Controller 実装 (OrderController, OrderItemController)
5. ✅ ルート定義
6. ✅ Computed properties 実装 (remaining_qty, is_sold_out, available_qty)
7. ✅ バリデーション実装
8. ✅ 履歴記録ロジック実装
9. ✅ ソフト削除実装
10. ✅ テスト実行 → グリーン

## 今後の拡張

- [ ] リアルタイム WebSocket 更新（新着注文の即座通知）
- [ ] 複数ユーザーの同時編集ロック
- [ ] 提供数の履歴オーディット
- [ ] 日次レポート生成
- [ ] 在庫自動調整機能
