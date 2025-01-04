# Exit on Error
set -e

KEYSTORE_TO_UPGRADE=/secrets/keystore/elasticsearch.keystore
KEYSTORE_TO_UPGRADE_BACKUP=$KEYSTORE_TO_UPGRADE.pre-upgrade
KEYSTORE_LOCATION_FOR_TOOL=/usr/share/elasticsearch/config/elasticsearch.keystore

if [ -f $KEYSTORE_TO_UPGRADE_BACKUP ]; then
    echo "A backup of a previous run of this script was found at $KEYSTORE_TO_UPGRADE_BACKUP. Aborting execution!"
    echo "Please remove the backup file and run the script again if you're sure that you want to run the upgrade script again."
    exit 1
fi

echo "=========== Upgrading Elasticsearch Keystore =========="

cp $KEYSTORE_TO_UPGRADE $KEYSTORE_LOCATION_FOR_TOOL

echo "Running elasticsearch-keystore upgrade"
elasticsearch-keystore upgrade

mv $KEYSTORE_TO_UPGRADE $KEYSTORE_TO_UPGRADE_BACKUP
mv $KEYSTORE_LOCATION_FOR_TOOL $KEYSTORE_TO_UPGRADE

echo "======= Keystore upgrade completed successfully ======="
echo "Old keystore was backed up to $KEYSTORE_TO_UPGRADE_BACKUP"
