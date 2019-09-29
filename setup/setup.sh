# Exit on Error
set -e

echo "=== Creating Elasticsearch Keystore ==="
# Replace current Keystore
if [ -f "keystore/elasticsearch.keystore" ]; then
    echo "Remove old elasticsearch.keystore"
    rm /keystore/elasticsearch.keystore
fi

# Password Generate
PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ;)
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-$PW}"
export ELASTIC_PASSWORD
echo "Elastic password is: $ELASTIC_PASSWORD"

# Create Keystore
elasticsearch-keystore create >> /dev/null

# Setting Secrets
sh /setup/keystore.sh

echo "Saving new keystore..."
mv config/elasticsearch.keystore /keystore/elasticsearch.keystore
chmod 0644 /keystore/elasticsearch.keystore