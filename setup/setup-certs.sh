# Exit on Error
set -e

OUTPUT_DIR=/secrets/certs
CA_ZIP=$OUTPUT_DIR/elastic-stack-ca.zip
CERT_ZIP=$OUTPUT_DIR/elastic-certificates.zip

if ! command -v unzip &>/dev/null; then
echo "Install unzip if needed..."
    yum -qy install unzip &> /dev/null
fi

printf "====== Generating Elasticsearch Certifications ======\n"
printf "=====================================================\n"

if [ -f "$CA_ZIP" ]; then rm $CA_ZIP; fi
elasticsearch-certutil ca -s --pem --out $CA_ZIP
unzip $CA_ZIP -d $OUTPUT_DIR &>/dev/null
mv $OUTPUT_DIR/ca/ca.key $OUTPUT_DIR/elastic-ca.key
mv $OUTPUT_DIR/ca/ca.crt $OUTPUT_DIR/elastic-ca.crt
rm -rf $OUTPUT_DIR/ca
rm -rf $CA_ZIP


if [ -f "$CERT_ZIP" ]; then rm $CERT_ZIP; fi
elasticsearch-certutil cert --silent --pem --out $CERT_ZIP --ca-cert $OUTPUT_DIR/elastic-ca.crt --ca-key $OUTPUT_DIR/elastic-ca.key
unzip $CERT_ZIP -d $OUTPUT_DIR &>/dev/null
mv $OUTPUT_DIR/instance/instance.key $OUTPUT_DIR/elastic.key
mv $OUTPUT_DIR/instance/instance.crt $OUTPUT_DIR/elastic.crt
rm -rf $OUTPUT_DIR/instance
rm -rf $CERT_ZIP


printf "=====================================================\n"
printf "SSL Certifications generation completed successfully.\n"
printf "=====================================================\n"
