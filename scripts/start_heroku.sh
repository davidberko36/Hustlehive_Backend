#!/bin/bash

# Default to gateway if not set (or fail)
if [ -z "$SERVICE_TYPE" ]; then
  echo "Error: SERVICE_TYPE environment variable not set."
  echo "Set it to 'gateway', 'product', or 'payment'."
  exit 1
fi

echo "Starting service: $SERVICE_TYPE"

if [ "$SERVICE_TYPE" = "gateway" ]; then
  cd gateway
  # Run using go run (simplest for mixed repo without complex build steps)
  go run main.go
elif [ "$SERVICE_TYPE" = "product" ]; then
  cd product-service
  go run main.go
elif [ "$SERVICE_TYPE" = "payment" ]; then
  cd payment-service
  # Run using gunicorn with uvicorn workers
  # Ensure PORT is passed to gunicorn (Heroku sets $PORT)
  gunicorn -k uvicorn.workers.UvicornWorker -w 2 -b 0.0.0.0:$PORT main:app
else
  echo "Error: Unknown SERVICE_TYPE '$SERVICE_TYPE'"
  exit 1
fi
