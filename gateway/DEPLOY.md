Gateway service (Go + Gin) - Heroku deployment

This folder contains the gateway service. Recommended: turn this folder into its own Git repository and deploy independently.

Quick commands (run from inside `gateway/`):

1) Initialize a new repo and push to GitHub

```powershell
cd gateway
git init
git add .
git commit -m "gateway: initial"
# create a GitHub repo then:
git remote add origin <git-url>
git push -u origin main
```

2) Create a Heroku app and set Go buildpack

```powershell
heroku create hustlehive-gateway
heroku buildpacks:set heroku/go -a hustlehive-gateway
```

3) Set config vars (replace values)

```powershell
heroku config:set JWT_SECRET=your_jwt_secret -a hustlehive-gateway
# If gateway calls product service, set PRODUCT_SERVICE_URL
heroku config:set PRODUCT_SERVICE_URL=https://<your-product-app>.herokuapp.com -a hustlehive-gateway
```

4) (Optional) Add Postgres

```powershell
heroku addons:create heroku-postgresql:hobby-dev -a hustlehive-gateway
```

5) Deploy

```powershell
# add remote if needed
heroku git:remote -a hustlehive-gateway -r heroku-gateway
git push heroku-gateway main
# or use GitHub integration in Heroku Dashboard
```

Notes
- The service reads `PORT` from environment; Heroku provides `PORT` automatically.
- The `Procfile` runs `go run main.go`. If you prefer a compiled binary, change the Procfile to the path of the binary built during release.
- Check logs: `heroku logs --tail -a hustlehive-gateway`
