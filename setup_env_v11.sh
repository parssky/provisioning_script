#!/usr/bin/env bash
set -Eeuo pipefail

# --- Required env vars ---
: "${CONFIG:?Set CONFIG in the environment (e.g., export CONFIG=configV1.sh)}"
: "${TOKEN:?Set TOKEN in the environment (e.g., export TOKEN=my_secret_token)}"

# --- Optional: override the URL via env (defaults to your given URL) ---
SERVER_URL="${SERVER_URL:-http://46.245.79.23:9530/get-script}"

# --- Activate your environment ---
cd /workspace
. /venv/main/bin/activate

# --- Fetch script from server ---
TMP_SCRIPT="$(mktemp /tmp/fetched-script.XXXXXX.sh)"
cleanup() { rm -f "$TMP_SCRIPT"; }
trap cleanup EXIT

echo "Requesting script from: $SERVER_URL (config=$CONFIG)"
http_status="$(
  curl -sS -o "$TMP_SCRIPT" -w "%{http_code}" \
    -X POST "$SERVER_URL" \
    -H "Content-Type: application/json" \
    -d "{\"config\":\"$CONFIG\",\"token\":\"$TOKEN\"}"
)"

if [[ "$http_status" != "200" ]]; then
  echo "ERROR: Server returned HTTP $http_status" >&2
  echo "Response body:" >&2
  sed -n '1,200p' "$TMP_SCRIPT" >&2
  exit 1
fi

# --- Execute the fetched script ---
chmod +x "$TMP_SCRIPT"
# Export env so the fetched script can use them too if needed
export CONFIG TOKEN
echo "Executing fetched script: $TMP_SCRIPT"
bash "$TMP_SCRIPT"
