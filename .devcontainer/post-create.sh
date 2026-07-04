#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="/workspace"
API_DIR="$WORKSPACE_DIR/api"
FRONT_DIR="$WORKSPACE_DIR/front-pharma"

echo "==> [1/6] Installing api dependencies..."
(cd "$API_DIR" && npm ci)

echo "==> [2/6] Installing front-pharma dependencies..."
(cd "$FRONT_DIR" && npm ci)

echo "==> [3/6] Bootstrapping api/.env ..."
if [ ! -f "$API_DIR/.env" ]; then
  cp "$API_DIR/.env.txt" "$API_DIR/.env"
  echo "    Created api/.env from api/.env.txt"
fi

# Point DATABASE_URL at the compose 'db' service (idempotent: always normalize)
sed -i -E 's#^DATABASE_URL=.*#DATABASE_URL="postgresql://medilogix:medilogix@db:5432/medilogix?schema=public"#' "$API_DIR/.env"

# Ensure CORS is open for local dev if left blank
if grep -qE '^CORS_ORIGIN=$' "$API_DIR/.env"; then
  sed -i -E 's#^CORS_ORIGIN=.*#CORS_ORIGIN=*#' "$API_DIR/.env"
fi

echo "==> [4/6] Generating RS256 JWT keypair (if missing)..."
if grep -qE '^JWT_PRIVATE_KEY=$' "$API_DIR/.env"; then
  mkdir -p "$API_DIR/keys"
  if [ ! -f "$API_DIR/keys/private.pem" ]; then
    openssl genrsa -out "$API_DIR/keys/private.pem" 2048 2>/dev/null
    openssl rsa -in "$API_DIR/keys/private.pem" -pubout -out "$API_DIR/keys/public.pem" 2>/dev/null
    echo "    Generated new RSA keypair at api/keys/"
  fi

  PRIVATE_B64=$(base64 -w 0 "$API_DIR/keys/private.pem")
  PUBLIC_B64=$(base64 -w 0 "$API_DIR/keys/public.pem")

  sed -i -E "s#^JWT_PRIVATE_KEY=.*#JWT_PRIVATE_KEY=${PRIVATE_B64}#" "$API_DIR/.env"
  sed -i -E "s#^JWT_PUBLIC_KEY=.*#JWT_PUBLIC_KEY=${PUBLIC_B64}#" "$API_DIR/.env"
  echo "    Wrote base64-encoded keys into api/.env"
else
  echo "    JWT keys already present in api/.env — skipping generation."
fi

echo "==> [5/6] Bootstrapping front-pharma environment.ts ..."
if [ ! -f "$FRONT_DIR/src/environments/environment.ts" ]; then
  cp "$FRONT_DIR/src/environments/environment.ts.dist" "$FRONT_DIR/src/environments/environment.ts"
fi
if grep -q "url: ''" "$FRONT_DIR/src/environments/environment.ts"; then
  sed -i "s#url: ''#url: 'http://localhost:3000'#" "$FRONT_DIR/src/environments/environment.ts"
fi

echo "==> [6/6] Waiting for database and applying Prisma migrations..."
until pg_isready -h db -p 5432 -U medilogix >/dev/null 2>&1; do
  echo "    Waiting for db..."
  sleep 2
done
(cd "$API_DIR" && npx prisma generate && npx prisma migrate deploy)

echo "==> post-create.sh done."
