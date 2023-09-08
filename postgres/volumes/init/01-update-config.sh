#!/bin/sh

# Replace the default pg_hba.conf with customized version
cp -p /tmp/config/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf

# Update the datestyle in postgresql.conf
sed -i -e "s/datestyle = 'iso, mdy'/datestyle = 'iso, ymd'/" /var/lib/postgresql/data/postgresql.conf

