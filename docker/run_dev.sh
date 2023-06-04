#!/usr/bin/env sh

docker run --name client_service -p 5001:5001 \
  --env FLASK_ENV=development \
  --env LISTEN_HOST=0.0.0.0 \
  --env LISTEN_PORT=5001 \
  client-app:1.0
