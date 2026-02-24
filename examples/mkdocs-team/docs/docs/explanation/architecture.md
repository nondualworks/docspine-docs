# Architecture

## Overview

The Checkout API follows a hexagonal architecture pattern, separating business logic from infrastructure concerns.

## Key Design Decisions

**Event-driven order processing:** Orders are processed asynchronously via an event bus rather than synchronous API calls. This decouples the checkout flow from downstream services (inventory, fulfillment, notifications).

**Idempotent payments:** All payment operations use idempotency keys to prevent duplicate charges. The checkout session ID serves as the natural idempotency key.

**Cart ownership:** Carts are owned by the checkout domain, not the product catalog. This allows the checkout flow to maintain its own state without coupling to catalog availability.
