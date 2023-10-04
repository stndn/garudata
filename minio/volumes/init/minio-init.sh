#!/bin/bash

# This script will create:
# - One new user
# - Two new buckets
# - Two new policies to allow read and write to the two new buckets, attached to the new user
# - Optionally create access key for the new user

# Connect to the S3 server
mc alias set garudas3 ${MINIO_SERVER_URL} ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}

# Create new user
mc admin user add garudas3 ${MINIO_EXTRA_USER} ${MINIO_EXTRA_PASSWORD}

# Create buckets to store intermediary and raw files
mc mb --ignore-existing garudas3/${MINIO_EXTRA_BUCKET_1}
mc mb --ignore-existing garudas3/${MINIO_EXTRA_BUCKET_2}

# Create policies based on pre-defined policy, with matching read and write permissions to the buckets
sed -e "s/%%BUCKET-NAME%%/${MINIO_EXTRA_BUCKET_1}/" /tmp/minio-init/policy_template_readwrite.json > /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_1_READWRITE}.json
sed -e "s/%%BUCKET-NAME%%/${MINIO_EXTRA_BUCKET_2}/" /tmp/minio-init/policy_template_readwrite.json > /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_2_READWRITE}.json

# Attach policieCreate policies based on pre-defined filesLoad pre-defined policies that match the buckets
mc admin policy create garudas3/ ${MINIO_EXTRA_BUCKET_1_READWRITE} /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_1_READWRITE}.json
mc admin policy create garudas3/ ${MINIO_EXTRA_BUCKET_2_READWRITE} /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_2_READWRITE}.json

# Assign the new policies to the user
mc admin policy attach garudas3 ${MINIO_EXTRA_BUCKET_1_READWRITE} --user ${MINIO_EXTRA_USER}
mc admin policy attach garudas3 ${MINIO_EXTRA_BUCKET_2_READWRITE} --user ${MINIO_EXTRA_USER}

# Create access key if enabled, and save the credentials in a file.
# Please keep the credentials a secret
if [ "${MINIO_EXTRA_CREATE_ACCESS_KEY}" == 'Y' ]; then
  mc admin user svcacct add garudas3 ${MINIO_EXTRA_USER} > /credentials/access_key_${MINIO_EXTRA_USER}.txt
fi

exit 0
