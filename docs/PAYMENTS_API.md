# Payments API (Backend contract for client-side Stripe flow)

This document describes the minimal backend endpoints expected by the app's client-side Stripe integration (`lib/core/services/payment_service.dart`). The backend is responsible for creating and confirming Stripe PaymentIntents and returning lightweight JSON responses the client uses to proceed.

Notes:
- The client performs sensitive card collection using `flutter_stripe` CardField and calls these endpoints with the PaymentMethod ID when required.
- Server must use Stripe secret key and implement idempotency & proper error handling.

## POST /payments/process
Create a PaymentIntent for an upcoming charge.

Request body (JSON):
- amount: number (required) — amount in the smallest currency unit (cents for USD) or your backend may accept a float in standard unit; coordinate with backend team.
- currency: string (required) — e.g. "usd"
- payment_method_id: string (optional) — the ID returned by client createPaymentMethod step.

Example request:
{
  "amount": 1000,
  "currency": "usd",
  "payment_method_id": "pm_1FhXYZ..."
}

Successful response (JSON):
- client_secret: string — the PaymentIntent client_secret the client may use to confirm or perform additional actions.
- status: string — e.g. `requires_confirmation`, `requires_action`, `succeeded`.
- requires_action: boolean (optional) — true if client-side action required.

Example response:
{
  "client_secret": "pi_1FhXYZ_secret_...",
  "status": "requires_confirmation"
}

Error response:
- return HTTP 4xx/5xx with a JSON body describing the error.

## POST /payments/confirm
Request backend to attempt confirmation of a PaymentIntent (server-side finalization).

Request body (JSON):
- payment_intent_client_secret: string (required) — client_secret returned by `/payments/process`.
- payment_method_id: string (optional) — payment method to attach or confirm with.

Example request:
{
  "payment_intent_client_secret": "pi_..._secret_...",
  "payment_method_id": "pm_1F..."
}

Successful response (JSON):
- status: string — e.g. `succeeded`, `requires_action`, `requires_confirmation`.
- requires_action: boolean (optional)
- client_secret: string (optional) — may be returned if further client action is required.

Example response when client must handle 3DS:
{
  "status": "requires_action",
  "requires_action": true,
  "client_secret": "pi_..._secret_..."
}

Example success response:
{
  "status": "succeeded"
}

Error response:
- return HTTP 4xx/5xx with a JSON body describing the error.

## Security & Idempotency
- Use Stripe secret key server-side only.
- Implement idempotency keys for retry-safe PaymentIntent creations.
- Validate amounts and currencies against your server-side order state.

## Webhooks
- Implement Stripe webhooks (e.g., `payment_intent.succeeded`, `payment_intent.payment_failed`) to reconcile final payment state.

## Testing
- Use Stripe test keys and https endpoints during development.
- Use Stripe test cards (e.g., 4242 4242 4242 4242) to simulate flows.

## Notes for Frontend
- The app's `PaymentServiceImpl` expects the above endpoints and will:
  1. POST `/payments/process` with amount, currency, and payment method id.
  2. Use returned `client_secret` to complete confirmation client-side if required.
  3. POST `/payments/confirm` to tell the backend to finalize confirmation; backend may return `requires_action` and `client_secret` for further client handling.

If you want a sample Node/Express or Firebase Function implementation scaffold, ask and I can generate it.
