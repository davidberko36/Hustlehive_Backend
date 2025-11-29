Product service (Go + Gin) - Heroku deployment

This folder contains the product service. Recommended: make this folder its own Git repository.

Quick commands (run from inside `product-service/`):

1) Initialize a new repo and push to GitHub

```powershell
cd product-service
git init
git add .
git commit -m "product-service: initial"
# create remote GitHub repo then:
git remote add origin <git-url>
git push -u origin main
```

2) Create a Heroku app and set buildpack

```powershell
heroku create hustlehive-product
heroku buildpacks:set heroku/go -a hustlehive-product
```

3) Set config vars (replace values)

```powershell
heroku config:set JWT_SECRET=your_jwt_secret -a hustlehive-product
# If using DATABASE_URL, ensure DB connection string is configured in code or via env
```

4) (Optional) Add Postgres

```powershell
heroku addons:create heroku-postgresql:hobby-dev -a hustlehive-product
```

5) Deploy

```powershell
heroku git:remote -a hustlehive-product -r heroku-product
git push heroku-product main
```

Notes
- Service reads `PORT` from environment; Heroku sets it automatically.
- Check logs: `heroku logs --tail -a hustlehive-product`
