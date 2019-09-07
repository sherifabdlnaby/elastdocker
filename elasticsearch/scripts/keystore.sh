# Exit on Error
set -e


# Setting Bootstrap Password
echo "Setting bootstrap.password..."
(echo "$ELASTIC_PASSWORD" | bin/elasticsearch-keystore add -x 'bootstrap.password')

# ----- Setting Secrets

## Add Additional Config
# 1- Copy the below commented block, uncomment it, and replace <name>, <key>, and <KEY_ENV_VALUE>.
# 2- Pass <KEY_ENV_VALUE> to setup container in `docker-compose-setup.yml`

# Setting S3 Access Key
echo "Setting S3 Access Key..."
(echo "$AWS_ACCESS_KEY_ID" | bin/elasticsearch-keystore add -x 's3.client.default.access_key')

# Setting S3 Secret Key
echo "Setting S3 Secret Key..."
(echo "$AWS_SECRET_ACCESS_KEY" | bin/elasticsearch-keystore add -x 's3.client.default.secret_key')

## Setting <name>
#echo "Setting <name>..."
#(echo "$<KEY_ENV_VALUE>" | bin/elasticsearch-keystore add -x '<key>')
