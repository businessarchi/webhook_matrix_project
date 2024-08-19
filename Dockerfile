# Use the latest version of the matrix-hookshot bridge
FROM ghcr.io/matrix-org/matrix-hookshot:latest

# Copy the configuration file
COPY config.yaml /data/config.yaml

# Generate a passkey file
RUN openssl genpkey -out /data/passkey.pem -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:4096

# Install sed for variable substitution
RUN apk add --no-cache sed openssl

# Startup command with enhanced debugging
CMD echo "Configuration before substitution:" && \
    cat /data/config.yaml && \
    sed -i \
        -e 's|${HOMESERVER_URL}|'"$HOMESERVER_URL"'|g' \
        -e 's|${HOMESERVER_DOMAIN}|'"$HOMESERVER_DOMAIN"'|g' \
        -e 's|${WEBHOOK_URL}|'"$WEBHOOK_URL"'|g' \
        -e 's|${PROVISION_SECRET}|'"$PROVISION_SECRET"'|g' \
        /data/config.yaml && \
    echo "Configuration after substitution:" && \
    cat /data/config.yaml && \
    echo "Starting matrix-hookshot..." && \
    node /usr/src/app/lib/App.js -c /data/config.yaml
