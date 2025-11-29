# Deploying Hustlehive Backend to Heroku

This project consists of three microservices (Gateway, Product, Payment) in a single repository. To deploy this to Heroku, you will create three separate Heroku apps, all deployed from this same repository, but configured to run different services.

## Prerequisites

- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed and logged in (`heroku login`).
- Git initialized and committed.

## Deployment Steps

### 1. Create Heroku Apps

Create three apps (replace `your-app-name` with unique names):

```bash
heroku create hustlehive-gateway
heroku create hustlehive-product
heroku create hustlehive-payment
```

### 2. Configure Buildpacks

Since this is a mixed-language repo (Go and Python), you need to add buildpacks to **all three apps** so Heroku can build the dependencies for both languages.

Run these commands for **EACH** of the three apps:

```bash
# For Gateway App
heroku buildpacks:add heroku/go -a hustlehive-gateway
heroku buildpacks:add heroku/python -a hustlehive-gateway

# For Product App
heroku buildpacks:add heroku/go -a hustlehive-product
heroku buildpacks:add heroku/python -a hustlehive-product

# For Payment App
heroku buildpacks:add heroku/go -a hustlehive-payment
heroku buildpacks:add heroku/python -a hustlehive-payment
```

### 3. Configure Environment Variables

Set the `SERVICE_TYPE` variable to tell each app which service to run.

**Gateway App:**
```bash
heroku config:set SERVICE_TYPE=gateway -a hustlehive-gateway
heroku config:set PRODUCT_SERVICE_URL=https://hustlehive-product.herokuapp.com -a hustlehive-gateway
heroku config:set JWT_SECRET=your_secret_key -a hustlehive-gateway
```

**Product App:**
```bash
heroku config:set SERVICE_TYPE=product -a hustlehive-product
heroku config:set JWT_SECRET=your_secret_key -a hustlehive-product
```

**Payment App:**
```bash
heroku config:set SERVICE_TYPE=payment -a hustlehive-payment
# Add other payment config vars (API_KEY, etc.)
heroku config:set SUBSCRIPTION_PRIMARY_KEY=... -a hustlehive-payment
heroku config:set API_USER_ID=... -a hustlehive-payment
heroku config:set API_KEY=... -a hustlehive-payment
heroku config:set TARGET_ENVIRONMENT=... -a hustlehive-payment
heroku config:set MOMO_BASE_URL=... -a hustlehive-payment
```

### 4. Database Setup (Postgres)

Heroku uses PostgreSQL. The code has been updated to use `DATABASE_URL` if available.

**Add Postgres to Gateway:**
```bash
heroku addons:create heroku-postgresql:mini -a hustlehive-gateway
```

**Add Postgres to Product:**
```bash
heroku addons:create heroku-postgresql:mini -a hustlehive-product
```

**Add Postgres to Payment:**
```bash
heroku addons:create heroku-postgresql:mini -a hustlehive-payment
```

### 5. Deploy

Push the code to Heroku. You need to push to each app.

```bash
# Add remotes if not already added (heroku create usually adds one 'heroku' remote)
heroku git:remote -a hustlehive-gateway -r heroku-gateway
heroku git:remote -a hustlehive-product -r heroku-product
heroku git:remote -a hustlehive-payment -r heroku-payment

# Push to all
git push heroku-gateway main
git push heroku-product main
git push heroku-payment main
```

## Troubleshooting

- **Logs**: Check logs with `heroku logs --tail -a <app-name>`.
- **Build Errors**: Ensure `go.mod` and `requirements.txt` are correct.
- **Database**: If tables are not created, check the logs. The Go services use `AutoMigrate` on startup.
