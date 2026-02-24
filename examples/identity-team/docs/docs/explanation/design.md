# Design and Architecture

## Why a centralized auth gateway

Each service handling its own auth leads to inconsistent enforcement, duplicated logic, and no single place to update policies. Auth Gateway centralizes token issuance and validation so that a policy change (new expiry, new scope requirement) applies everywhere without coordinating across teams.

## Token format

Auth Gateway issues JWTs signed with RS256. The public key is available at `/.well-known/jwks.json` for services that want to validate tokens locally without a network call.

## Trust model

Services trust any token signed by Auth Gateway's private key. They validate the signature, expiry, and required scopes. They do not call Auth Gateway on every request — local validation keeps latency low.

## Scopes

Scopes are coarse-grained by service: `checkout:read`, `checkout:write`, `identity:admin`. Fine-grained permissions are the responsibility of each service using the claims in the token.
