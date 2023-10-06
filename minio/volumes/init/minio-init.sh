#!/bin/bash

# This script will create:
# - One new user
# - Two new buckets
# - Two new policies to allow read and write to the two new buckets, attached to the new user
# - Optionally create access key for the new user

# Connect to the S3 server
mc alias set garudas3 ${MINIO_SERVER_URL} ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}

# Create new user
if [ $(mc admin user info garudas3 ${MINIO_EXTRA_USER} | grep '^${MINIO_EXTRA_USER}$' | wc -l) -eq 0 ]; then
  mc admin user add garudas3 ${MINIO_EXTRA_USER} ${MINIO_EXTRA_PASSWORD}
else
  echo "Not creating new user: '${MINIO_EXTRA_USER}' exists"
fi


# Create buckets to store intermediary and raw files
mc mb --ignore-existing garudas3/${MINIO_EXTRA_BUCKET_1}
mc mb --ignore-existing garudas3/${MINIO_EXTRA_BUCKET_2}

#
# Create policies based on pre-defined policy, with matching read and write permissions to the buckets
if [ ! -f "/tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_1_POLICY}.json" ]; then
  sed -e "s/%%BUCKET-NAME%%/${MINIO_EXTRA_BUCKET_1}/" /tmp/minio-init/policy_template_readwrite.json > /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_1_POLICY}.json
else
  echo "Not creating a new policy file: '${MINIO_EXTRA_BUCKET_1_POLICY}.json' exists"
fi

if [ ! -f "/tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_2_POLICY}.json" ]; then
  sed -e "s/%%BUCKET-NAME%%/${MINIO_EXTRA_BUCKET_2}/" /tmp/minio-init/policy_template_readwrite.json > /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_2_POLICY}.json
else
  echo "Not creating a new policy file: '${MINIO_EXTRA_BUCKET_2_POLICY}.json' exists"
fi


# Attach policieCreate policies based on pre-defined filesLoad pre-defined policies that match the buckets
if [ $(mc admin policy ls garudas3 | grep '^${MINIO_EXTRA_BUCKET_1_POLICY}$' | wc -l) -eq 0 ]; then
  mc admin policy create garudas3/ ${MINIO_EXTRA_BUCKET_1_POLICY} /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_1_POLICY}.json
else
  echo "Not creating a new policy: '${MINIO_EXTRA_BUCKET_1_POLICY}' exists"
fi

if [ $(mc admin policy ls garudas3 | grep '^${MINIO_EXTRA_BUCKET_2_POLICY}$' | wc -l) -eq 0 ]; then
  mc admin policy create garudas3/ ${MINIO_EXTRA_BUCKET_2_POLICY} /tmp/minio-init/policy_${MINIO_EXTRA_BUCKET_2_POLICY}.json
else
  echo "Not creating a new policy: '${MINIO_EXTRA_BUCKET_2_POLICY}' exists"
fi


# Assign the new policies to the user
if [ $(mc admin policy entities garudas3 -u ${MINIO_EXTRA_USER} | grep '^${MINIO_EXTRA_BUCKET_1_POLICY}$' | wc -l) -eq 0 ]; then
  mc admin policy attach garudas3 ${MINIO_EXTRA_BUCKET_1_POLICY} --user ${MINIO_EXTRA_USER}
else
  echo "Not attaching the policy to user '${MINIO_EXTRA_USER}': '${MINIO_EXTRA_BUCKET_1_POLICY}' is already assigned"
fi

if [ $(mc admin policy entities garudas3 -u ${MINIO_EXTRA_USER} | grep '^${MINIO_EXTRA_BUCKET_2_POLICY}$' | wc -l) -eq 0 ]; then
  mc admin policy attach garudas3 ${MINIO_EXTRA_BUCKET_2_POLICY} --user ${MINIO_EXTRA_USER}
else
  echo "Not attaching the policy to user '${MINIO_EXTRA_USER}': '${MINIO_EXTRA_BUCKET_2_POLICY}' is already assigned"
fi


# Create access key if enabled, and save the credentials in a file.
# Only if no access key exists
# Please keep the credentials a secret
if [ "${MINIO_EXTRA_CREATE_ACCESS_KEY}" == 'Y' ]; then
  key_count=$(mc admin user svcacct list garudas3 ${MINIO_EXTRA_USER} | grep -v 'Access Key' | wc -l)

  if [ $key_count -eq 0 ]; then
    mc admin user svcacct add garudas3 ${MINIO_EXTRA_USER} > /credentials/access_key_${MINIO_EXTRA_USER}.txt
  else
    echo "Not creating a new access key: ${key_count} key(s) exists"
  fi
fi

exit 0
