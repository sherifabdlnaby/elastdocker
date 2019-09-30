# Exit on Error
set -e

OUTPUT_DIR=/secrets/certs
CA_FILE=$OUTPUT_DIR/elastic-stack-ca.p12
CERT_FILE=$OUTPUT_DIR/elastic-certificates.p12

printf "====== Generating Elasticsearch Certifications ======\n"
printf "=====================================================\n"
if [ -f "$CA_FILE" ]; then
    echo "Removing current Certificate Authority (CA)..."
    rm $CA_FILE
fi
if [ -f "$CERT_FILE" ]; then
    echo "Removing current Certificate (P12)..."
    rm $CERT_FILE
fi
elasticsearch-certutil ca -s --pass "" --out $CA_FILE
elasticsearch-certutil cert -s --ca $CA_FILE --ca-pass "" --out $CERT_FILE --pass ""
chmod 0644 $CA_FILE
chmod 0644 $CERT_FILE
printf "Certificate Authority created at $CA_FILE\n"
printf "Certificate created at $CERT_FILE\n"
printf "=====================================================\n"
printf "SSL Certifications generation completed successfully.\n"
printf "=====================================================\n"
