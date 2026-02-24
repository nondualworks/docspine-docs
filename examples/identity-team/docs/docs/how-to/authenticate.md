# How to Authenticate a Request

## Get a token

```bash
curl -X POST https://auth.company.com/token \
  -H "Content-Type: application/json" \
  -d '{"client_id": "your-client-id", "client_secret": "your-secret"}'
```

Response:

```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

## Use the token

Pass the token in the `Authorization` header on every request:

```bash
curl https://api.company.com/checkout \
  -H "Authorization: Bearer eyJ..."
```

## Token expiry

Tokens expire after 1 hour. Request a new token before expiry or handle 401 responses by re-authenticating.
