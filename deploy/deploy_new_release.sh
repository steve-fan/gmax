set -o xtrace
set -e

# Stop nuts_backend if possible
if pgrep run_erl; then
   ~/nuts_backend/_build/prod/rel/nuts/bin/nuts stop
fi
# kill epmd
if pgrep epmd; then
   kill `pgrep epmd`
fi

cd ~/nuts_backend
git checkout -- .
git pull
cd ~/nutsweb
git checkout -- .
git pull
yarn install
npm run build
cp ~/nutsweb/dist/*.js ~/nuts_backend/priv/static/js

cd ~/nuts_backend
mix deps.get --only prod
MIX_ENV=prod mix compile
npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest
MIX_ENV=prod mix release --overwrite


# start nuts server
~/nuts_backend/_build/prod/rel/nuts/bin/nuts daemon
