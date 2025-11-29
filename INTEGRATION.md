# Hustlehive Backend Integration Guide

This guide provides instructions on how to integrate the Hustlehive backend services with a Next.js frontend.

## System Overview

The backend consists of three main services:
1.  **Gateway Service (Go)**: The main entry point for Authentication and Product/Bid operations.
2.  **Product Service (Go)**: Handles items, categories, and bids (accessed via Gateway).
3.  **Payment Service (Python)**: Handles mobile money payments (accessed directly).

## Base URLs

| Service | Default URL | Description |
| :--- | :--- | :--- |
| **Gateway** | `http://localhost:8080` | Use for Auth, Products, Bids |
| **Payment** | `http://localhost:8000` | Use for Payments |

> **Tip:** In your Next.js project, store these in `.env.local`:
> ```bash
> NEXT_PUBLIC_API_GATEWAY_URL=http://localhost:8080
> NEXT_PUBLIC_PAYMENT_SERVICE_URL=http://localhost:8000
> ```

## Authentication

The system uses JWT (JSON Web Tokens) for authentication.

### 1. Register User
*   **Endpoint:** `POST /auth/register`
*   **URL:** `http://localhost:8080/auth/register`
*   **Body:**
    ```json
    {
      "username": "johndoe",
      "email": "john@example.com",
      "password": "securepassword",
      "full_name": "John Doe",
      "address": "123 Main St",
      "phone": "+1234567890"
    }
    ```

### 2. Login
*   **Endpoint:** `POST /auth/login`
*   **URL:** `http://localhost:8080/auth/login`
*   **Body:**
    ```json
    {
      "username": "johndoe", // or email depending on implementation
      "password": "securepassword"
    }
    ```
*   **Response:**
    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiIs..."
    }
    ```
    > **Action:** Store this `token` (e.g., in `localStorage` or cookies) and include it in the `Authorization` header for all protected requests.

### 3. Verify Token
*   **Endpoint:** `GET /auth/verify`
*   **URL:** `http://localhost:8080/auth/verify`
*   **Headers:** `Authorization: Bearer <token>`

---

## Products & Bids (Gateway Proxy)

All requests to these endpoints **must** include the `Authorization` header:
`Authorization: Bearer <your_jwt_token>`

### Items

| Action | Method | Endpoint | Body / Notes |
| :--- | :--- | :--- | :--- |
| **List Items** | `GET` | `/proxy/items` | Returns list of items |
| **Get Item** | `GET` | `/proxy/items/:id` | Returns single item details |
| **Create Item** | `POST` | `/proxy/items` | JSON Body (see Model below) |
| **Update Item** | `PUT` | `/proxy/items/:id` | JSON Body |
| **Delete Item** | `DELETE` | `/proxy/items/:id` | - |

**Item Model (JSON):**
```json
{
  "title": "Vintage Camera",
  "description": "A classic film camera.",
  "price": 150.00,
  "quantity": 1,
  "is_auction": true,
  "start_price": 100.00,
  "start_date": "2023-10-27T10:00:00Z",
  "end_date": "2023-11-03T10:00:00Z",
  "status": "active"
}
```

### Categories

| Action | Method | Endpoint | Body |
| :--- | :--- | :--- | :--- |
| **List Categories** | `GET` | `/proxy/categories` | - |
| **Create Category** | `POST` | `/proxy/categories` | `{"category_name": "Electronics", "parent_category_id": null}` |

### Bids

| Action | Method | Endpoint | Body |
| :--- | :--- | :--- | :--- |
| **Get Item Bids** | `GET` | `/proxy/bids/:item_id` | - |
| **Place Bid** | `POST` | `/proxy/bids` | `{"item_id": 1, "bid_amount": 120.00}` |

---

## Payments

The payment service is currently accessed directly.

### Request Payment (Momo)
*   **Endpoint:** `POST /payment/request`
*   **URL:** `http://localhost:8000/payment/request`
*   **Body:**
    ```json
    {
      "amount": "50.00",
      "currency": "EUR", 
      "payer_phone_number": "233xxxxxxxxx",
      "payer_message": "Payment for item #123",
      "payee_note": "Thanks for shopping"
    }
    ```
    > **Note:** `currency` defaults to "EUR" in the model, but "GHS" is mentioned for production. Check your specific environment configuration.

### Health Check
*   **Endpoint:** `GET /health`
*   **URL:** `http://localhost:8000/health`

---

## Next.js Integration Example

Here is a simple helper function example for your Next.js app:

```javascript
// utils/api.js
const GATEWAY_URL = process.env.NEXT_PUBLIC_API_GATEWAY_URL || 'http://localhost:8080';

export async function fetchWithAuth(endpoint, options = {}) {
  const token = localStorage.getItem('token'); // Or however you store it

  const headers = {
    'Content-Type': 'application/json',
    ...options.headers,
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${GATEWAY_URL}${endpoint}`, {
    ...options,
    headers,
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }

  return response.json();
}

// Usage:
// const items = await fetchWithAuth('/proxy/items');
```
