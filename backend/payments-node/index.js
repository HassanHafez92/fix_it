require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const Stripe = require('stripe');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

// Simple in-memory store for intents (demo only)
const intents = new Map();

// POST /payments/process
// Body: { amount, currency, payment_method_id }
// Returns: { client_secret, status }
app.post('/payments/process', async (req, res) => {
  try {
    const { amount, currency, payment_method_id } = req.body;
    if (!amount || !currency) {
      return res.status(400).json({ error: 'amount and currency are required' });
    }

    // Create PaymentIntent on behalf of the client.
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency: currency,
      payment_method: payment_method_id || undefined,
      confirmation_method: 'manual',
      confirm: false,
    });

    // store minimal state
    intents.set(paymentIntent.id, { status: paymentIntent.status, client_secret: paymentIntent.client_secret });

    res.json({ client_secret: paymentIntent.client_secret, status: paymentIntent.status });
  } catch (err) {
    console.error('process error', err);
    res.status(500).json({ error: err.message });
  }
});

// POST /payments/confirm
// Body: { payment_intent_client_secret, payment_method_id }
// Returns: { status, requires_action?, client_secret? }
app.post('/payments/confirm', async (req, res) => {
  try {
    const { payment_intent_client_secret, payment_method_id } = req.body;
    if (!payment_intent_client_secret) {
      return res.status(400).json({ error: 'payment_intent_client_secret required' });
    }

    // Retrieve intent by client_secret - Stripe API doesn't allow fetch by client_secret, so
    // as a simple demo we search our in-memory map for a matching client_secret.
    const entry = Array.from(intents.entries()).find(([, v]) => v.client_secret === payment_intent_client_secret);
    if (!entry) {
      return res.status(404).json({ error: 'PaymentIntent not found' });
    }
    const intentId = entry[0];

    // Attach payment_method if provided
    if (payment_method_id) {
      await stripe.paymentMethods.attach(payment_method_id, { payment_intent: intentId }).catch(() => {});
    }

    // Confirm the PaymentIntent
    const confirmed = await stripe.paymentIntents.confirm(intentId, { payment_method: payment_method_id || undefined });

    // Update store
    intents.set(intentId, { status: confirmed.status, client_secret: confirmed.client_secret });

    const response = { status: confirmed.status };
    if (confirmed.status === 'requires_action' || confirmed.next_action) {
      response.requires_action = true;
      response.client_secret = confirmed.client_secret;
    }

    res.json(response);
  } catch (err) {
    console.error('confirm error', err);
    res.status(500).json({ error: err.message });
  }
});

const port = process.env.PORT || 4242;
app.listen(port, () => console.log(`Payments demo server listening on ${port}`));
