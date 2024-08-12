FROM docker.io/matrixdotorg/hookshot:latest

# Installer OpenSSL
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de configuration
COPY hookshot-config.yaml /config/config.yaml
COPY passkey.pem /config/passkey.pem

# Générer la clé si elle n'existe pas
RUN if [ ! -s /config/passkey.pem ]; then \
        openssl genpkey -out /config/passkey.pem -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:4096; \
    fi

EXPOSE 9000

CMD ["node", "lib/index.js", "-c", "/config/config.yaml"]
