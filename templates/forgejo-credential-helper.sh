#!/bin/sh
# Git credential helper: answers only for https://forgejo.<externalDomain>.
DOMAIN_FILE="${sopsPath:external-domain}"
TOKEN_FILE="${sopsPath:forgejo-token}"
USERNAME_FILE="${sopsPath:forgejo-user-name}"

[ -f "$TOKEN_FILE" ] && [ -f "$DOMAIN_FILE" ] && [ -f "$USERNAME_FILE" ] || exit 0

host=""
protocol=""
while IFS='=' read -r key value; do
  case "$key" in
    host) host="$value" ;;
    protocol) protocol="$value" ;;
  esac
done

if [ "$host" = "forgejo.$(cat "$DOMAIN_FILE")" ] && [ "$protocol" = "https" ]; then
  echo "username=$(cat "$USERNAME_FILE")"
  echo "password=$(cat "$TOKEN_FILE")"
fi
