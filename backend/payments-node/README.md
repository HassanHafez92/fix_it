Payments Node demo

This is a minimal Node/Express demo implementing the backend endpoints expected by the Flutter client in this repo.

Quick start

1. Copy `.env.example` to `.env` and set `STRIPE_SECRET_KEY`.

2. Install dependencies:

```powershell
cd backend/payments-node; npm install
```

3. Run in dev mode:

```powershell
npm run dev
```

Endpoints

- POST /payments/process
  - Body: { amount, currency, payment_method_id }
  - Response: { client_secret, status }

- POST /payments/confirm
  - Body: { payment_intent_client_secret, payment_method_id }
  - Response: { status, requires_action?, client_secret? }

Notes

- This demo uses an in-memory store and is not production-ready.
- Use Stripe secret key in `.env` and test card numbers from Stripe docs.
- For production, implement persistent storage, idempotency keys, proper error handling, and secure deployment.
