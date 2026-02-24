# API Reference

## Endpoints

### `POST /api/v1/checkout`

Creates a new checkout session.

**Request body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `cart_id` | string | yes | Cart identifier |
| `customer_id` | string | yes | Customer identifier |
| `payment_method` | string | yes | One of: `card`, `bank_transfer`, `wallet` |

**Response:** `201 Created`

```json
{
  "checkout_id": "chk_abc123",
  "status": "pending",
  "created_at": "2026-02-23T10:00:00Z"
}
```
