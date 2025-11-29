Payment service (Python + FastAPI) - Heroku deployment

This folder contains the payment service. Recommended: make this folder its own Git repository.

Pre-checks
- Ensure `requirements.txt` includes `fastapi`, `uvicorn[standard]`, and `python-dotenv` if you use `.env` locally.

Quick commands (run from inside `payment-service/`):

1) Initialize and push repo

```powershell
cd payment-service
git init
git add .
git commit -m "payment-service: initial"
# create remote GitHub repo then:
git remote add origin <git-url>
git push -u origin main
```

2) Create Heroku app and set Python buildpack

```powershell
heroku create hustlehive-payment
heroku buildpacks:set heroku/python -a hustlehive-payment
```

3) Set required config vars (replace values)

```powershell
heroku config:set SUBSCRIPTION_PRIMARY_KEY=... -a hustlehive-payment
heroku config:set API_USER_ID=... -a hustlehive-payment
heroku config:set API_KEY=... -a hustlehive-payment
heroku config:set TARGET_ENVIRONMENT=... -a hustlehive-payment
heroku config:set MOMO_BASE_URL=... -a hustlehive-payment
```

4) (Optional) Add Postgres

```powershell
heroku addons:create heroku-postgresql:hobby-dev -a hustlehive-payment
```

5) Deploy

```powershell
heroku git:remote -a hustlehive-payment -r heroku-payment
git push heroku-payment main
```

Notes
- Procfile runs Uvicorn with `PORT` from environment.
- Check logs: `heroku logs --tail -a hustlehive-payment`
