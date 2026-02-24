# API Reference

## POST /token

Issues a JWT access token.

**Request**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `client_id` | string | yes | Your service's client ID |
| `client_secret` | string | yes | Your service's client secret |
| `scope` | string | no | Space-separated list of requested scopes |

**Response**

| Field | Type | Description |
|-------|------|-------------|
| `access_token` | string | JWT bearer token |
| `token_type` | string | Always `"Bearer"` |
| `expires_in` | integer | Seconds until expiry |

## POST /token/introspect

Validates a token and returns its claims.

**Request**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `token` | string | yes | The JWT to validate |

**Response**

Returns the decoded token claims, or `{"active": false}` if the token is invalid or expired.

## POST /token/revoke

Revokes a token immediately.

**Request**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `token` | string | yes | The JWT to revoke |
