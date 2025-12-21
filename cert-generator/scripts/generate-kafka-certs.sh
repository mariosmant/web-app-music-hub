#!/bin/sh
set -e

# Requirements: openssl, keytool (from openjdk)
apk update >/dev/null
apk add --no-cache openssl >/dev/null
apk add --no-cache openjdk21-jre-headless >/dev/null

CERTS_DIR=/certs

CA_DIR="$CERTS_DIR/ca"
CTRL1_DIR="$CERTS_DIR/controller-1"
CTRL2_DIR="$CERTS_DIR/controller-2"
CTRL3_DIR="$CERTS_DIR/controller-3"
BROKER1_DIR="$CERTS_DIR/broker-1"
BROKER2_DIR="$CERTS_DIR/broker-2"
BROKER3_DIR="$CERTS_DIR/broker-3"
TRUST_DIR="$CERTS_DIR/truststore"
BROKER3_DIR="$CERTS_DIR/broker-3"
CONFL_SCHEMA_REGISTRY_DIR="$CERTS_DIR/confl-schema-registry"
CONNECT_DIR="$CERTS_DIR/connect"

mkdir -p "$CA_DIR" "$CTRL1_DIR" "$BROKER1_DIR" "$TRUST_DIR" "$CONFL_SCHEMA_REGISTRY_DIR" "$CONNECT_DIR"


KAFKA_CONTROLLER_1_KEYSTORE_PASSWORD="${KAFKA_CONTROLLER_1_KEYSTORE_PASSWORD:-}"
KAFKA_CONTROLLER_2_KEYSTORE_PASSWORD="${KAFKA_CONTROLLER_2_KEYSTORE_PASSWORD:-}"
KAFKA_CONTROLLER_3_KEYSTORE_PASSWORD="${KAFKA_CONTROLLER_3_KEYSTORE_PASSWORD:-}"
KAFKA_BROKER_1_KEYSTORE_PASSWORD="${KAFKA_BROKER_1_KEYSTORE_PASSWORD:-}"
KAFKA_BROKER_2_KEYSTORE_PASSWORD="${KAFKA_BROKER_2_KEYSTORE_PASSWORD:-}"
KAFKA_BROKER_3_KEYSTORE_PASSWORD="${KAFKA_BROKER_3_KEYSTORE_PASSWORD:-}"
KAFKA_CONFL_SCHEMA_REGISTRY_KEYSTORE_PASSWORD="${KAFKA_CONFL_SCHEMA_REGISTRY_KEYSTORE_PASSWORD:-}"
KAFKA_CONNECT_KEYSTORE_PASSWORD="${KAFKA_CONNECT_KEYSTORE_PASSWORD:-}"
TRUSTSTORE_PASSWORD="${TRUSTSTORE_PASSWORD:-}"
COUNTRY="${COUNTRY:-}"
STATE="${STATE:-}"
LOCALITY="${LOCALITY:-}"
ORG_NAME="${ORG_NAME:-}"
CA_CN="${CA_CN:-}"

echo "=== Generating Root CA (RSA 4096, SHA-384) ==="

if [ ! -f "$CA_DIR/root-ca.key" ]; then
  openssl genpkey -algorithm RSA \
    -pkeyopt rsa_keygen_bits:4096 \
    -out "$CA_DIR/root-ca.key"
fi

if [ ! -f "$CA_DIR/root-ca.crt" ]; then
  openssl req -x509 -new -key "$CA_DIR/root-ca.key" -sha384 -days 3650 \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/OU=Security/CN=$CA_CN" \
    -out "$CA_DIR/root-ca.crt"
fi

ROOT_CA_CRT="$CA_DIR/root-ca.crt"
ROOT_CA_KEY="$CA_DIR/root-ca.key"

generate_node_cert() {
  NODE_NAME="$1"
  NODE_DIR="$2"
  KEYSTORE_PASSWORD="$3"

  echo $KEYSTORE_PASSWORD

  echo "=== Generating cert for $NODE_NAME ==="
  mkdir -p "$NODE_DIR"

  # Private key
  openssl genpkey -algorithm RSA \
    -pkeyopt rsa_keygen_bits:4096 \
    -out "$NODE_DIR/$NODE_NAME.key"

  # CSR
  openssl req -new -key "$NODE_DIR/$NODE_NAME.key" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/OU=Kafka/CN=$NODE_NAME" \
    -out "$NODE_DIR/$NODE_NAME.csr"

  # SAN config
  EXT_FILE="$NODE_DIR/$NODE_NAME.ext"
  cat > "$EXT_FILE" <<EOF
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $NODE_NAME
DNS.2 = $NODE_NAME.appnet
DNS.3 = localhost
EOF

  # Sign CSR
  openssl x509 -req \
    -in "$NODE_DIR/$NODE_NAME.csr" \
    -CA "$ROOT_CA_CRT" \
    -CAkey "$ROOT_CA_KEY" \
    -CAcreateserial \
    -out "$NODE_DIR/$NODE_NAME.crt" \
    -days 825 \
    -sha384 \
    -extfile "$EXT_FILE"

  # PKCS12 keystore
  openssl pkcs12 -export \
    -in "$NODE_DIR/$NODE_NAME.crt" \
    -inkey "$NODE_DIR/$NODE_NAME.key" \
    -certfile "$ROOT_CA_CRT" \
    -name "$NODE_NAME" \
    -out "$NODE_DIR/$NODE_NAME-keystore.p12" \
    -passout pass:"$KEYSTORE_PASSWORD"

  echo "Generated keystore: $NODE_DIR/$NODE_NAME-keystore.p12"
}

# Controller and broker keystores
generate_node_cert "kafka-controller-1" "$CTRL1_DIR" "$KAFKA_CONTROLLER_1_KEYSTORE_PASSWORD"
generate_node_cert "kafka-controller-2" "$CTRL2_DIR" "$KAFKA_CONTROLLER_2_KEYSTORE_PASSWORD"
generate_node_cert "kafka-controller-3" "$CTRL3_DIR" "$KAFKA_CONTROLLER_3_KEYSTORE_PASSWORD"
generate_node_cert "kafka-broker-1" "$BROKER1_DIR" "$KAFKA_BROKER_1_KEYSTORE_PASSWORD"
generate_node_cert "kafka-broker-2" "$BROKER2_DIR" "$KAFKA_BROKER_2_KEYSTORE_PASSWORD"
generate_node_cert "kafka-broker-3" "$BROKER3_DIR" "$KAFKA_BROKER_3_KEYSTORE_PASSWORD"
generate_node_cert "kafka-confl-schema-registry" "$CONFL_SCHEMA_REGISTRY_DIR" "$KAFKA_CONFL_SCHEMA_REGISTRY_KEYSTORE_PASSWORD"
generate_node_cert "kafka-connect" "$CONNECT_DIR" "$KAFKA_CONNECT_KEYSTORE_PASSWORD"

echo "=== Generating truststore ==="

TRUSTSTORE_FILE="$TRUST_DIR/kafka-truststore.p12"

if [ -f "$TRUSTSTORE_FILE" ]; then
  rm -f "$TRUSTSTORE_FILE"
fi

keytool -importcert \
  -alias myorg-root-ca \
  -file "$ROOT_CA_CRT" \
  -keystore "$TRUSTSTORE_FILE" \
  -storetype PKCS12 \
  -storepass "$TRUSTSTORE_PASSWORD" \
  -noprompt

echo "Truststore: $TRUSTSTORE_FILE"

echo "=== Setting secure permissions ==="

# Private keys: owner read/write only
find "$CERTS_DIR" -type f -name "*.key" -exec chmod 600 {} \;

# Keystores & truststores: world-readable (Kafka runs as non-root)
find "$CERTS_DIR" -type f -name "*-keystore.p12" -exec chmod 644 {} \;
find "$CERTS_DIR" -type f -name "kafka-truststore.p12" -exec chmod 644 {} \;

# Certificates & CSRs: world-readable
find "$CERTS_DIR" -type f -name "*.crt" -exec chmod 644 {} \;
find "$CERTS_DIR" -type f -name "*.csr" -exec chmod 644 {} \;

echo "=== Permissions applied ==="

echo "=== Done ==="
