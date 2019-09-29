# Exit on Error
set -e

OUTPUT_FILE=/secrets/keystore/elasticsearch.keystore
NATIVE_FILE=/usr/share/elasticsearch/config/elasticsearch.keystore

# Password Generate
PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ;)
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-$PW}"
export ELASTIC_PASSWORD

# Create Keystore
printf "========== Creating Elasticsearch Keystore ==========\n"
printf "=====================================================\n"
elasticsearch-keystore create >> /dev/null

# Setting Secrets
echo "Elastic password is: $ELASTIC_PASSWORD"
sh /setup/keystore.sh

# Replace current Keystore
if [ -f "$OUTPUT_FILE" ]; then
    echo "Remove old elasticsearch.keystore"
    rm $OUTPUT_FILE
fi

echo "Saving new elasticsearch.keystore"
mv $NATIVE_FILE $OUTPUT_FILE
chmod 0644 $OUTPUT_FILE

printf "======= Keystore setup completed successfully =======\n"
printf "=====================================================\n"
printf "Remember to restart the stack, or reload secure settings if changed settings are hot-reloadable.\n"
printf "About Reloading Settings: https://www.elastic.co/guide/en/elasticsearch/reference/current/secure-settings.html#reloadable-secure-settings\n"
printf "Your 'elastic' user password is: $ELASTIC_PASSWORD\n"
printf "=====================================================\n"