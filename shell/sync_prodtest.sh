#!/bin/bash

set -e

PROD="pp-content-new-db.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com"
TEST="pp-content-dev-db.cthkpx3mbvub.ap-southeast-1.rds.amazonaws.com"
DATE=`date`

echo "Taking dump on $DATE"

export PGPASSWORD=contentdb;pg_dump -h $PROD -U root contentdb > sync_prodtest.sql

echo "dump completed"

export PGPASSWORD=homeironmanlogslumberSweeppy;psql -h $TEST -U groot bauxite < sync_prodtest.sql

echo "sync process completed"

