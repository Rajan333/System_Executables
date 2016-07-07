#!/bin/bash
#### AUTHOR == RAJAN ####
set -e

# CREATE SNAPSHOT FROM AN INSTANCE
CREATE_SNAPSHOT()
{
    echo "SNAPSHOT NAME: "
    read SNAPSHOT_NAME
    echo "SELECT AN INSTANCE: "
    read instance_no
    INSTANCE_NAME=${db_identifier_array[$instance_no-1]}
    echo $SNAPSHOT_NAME $INSTANCE_NAME
    #aws rds create-db-snapshot --db-snapshot-identifier $SNAPSHOT_NAME --db-instance-identifier $INSTANCE_NAME
}

# CREATE AN INSTANCE FROM A SNAPSHOT
CREATE_INSTANCE()
{
    # LIST ALL SNAPSHOTS OF INSTANCES
    aws rds describe-db-snapshots --query 'DBSnapshots[*][DBSnapshotIdentifier]' --output text | nl
    echo "SELECT A SNAPSHOT: "
    read snapshot_no
    SNAPSHOT_NAME=${snapshot_array[$snapshot_no-1]}
    echo "INSTANCE NAME: "
    read INSTANCE_NAME
    echo $SNAPSHOT_NAME $INSTANCE_NAME
    echo "Select Size:"
    echo "
    1.  db.m4.large 
    2.  db.m4.xlarge 
    3.  db.m4.2xlarge 
    4.  db.m4.4xlarge 
    5.  db.m4.10xlarge 
    6.  db.m3.medium 
    7.  db.m3.large 
    8.  db.m3.xlarge 
    9.  db.m3.2xlarge 
    10. db.r3.large 
    11. db.r3.xlarge 
    12. db.r3.2xlarge 
    13. db.r3.4xlarge 
    14. db.r3.8xlarge 
    15. db.t2.micro 
    16. db.t2.small 
    17. db.t2.medium 
    18. db.t2.large"
   
    echo "Enter no."
    read option
    case $option in
        1) SIZE="db.m4.large";;
        2) SIZE="db.m4.xlarge";;
        3) SIZE="db.m4.2xlarge";;
        4) SIZE="db.m4.4xlarge";;
        5) SIZE="db.m4.10xlarge";;
        6) SIZE="db.m3.medium";;
        7) SIZE="db.m3.large";;
        8) SIZE="db.m3.xlarge";;
        9) SIZE="db.m3.2xlarge";;
        10) SIZE="db.r3.large";;
        11) SIZE="db.r3.xlarge";;
        12) SIZE="db.r3.2xlarge";;
        13) SIZE="db.r3.4xlarge";;
        14) SIZE="db.r3.8xlarge";;
        15) SIZE="db.t2.micro";;
        16) SIZE="db.t2.small";;
        17) SIZE="db.t2.medium";;
        18) SIZE="db.t2.large";;
    esac
        echo $SIZE
        exit
        
    aws rds restore-db-instance-from-db-snapshot --db-instance-identifier $INSTANCE_NAME --db-snapshot-identifier $SNAPSHOT_NAME --db-instace-class $SIZE
}

# LIST ALL INSTANCES
LIST_INSTANCES()
{
    aws rds describe-db-instances --query 'DBInstances[*][DBInstanceIdentifier, DBInstanceClass, DBInstanceStatus, AvailabilityZone, InstanceCreateTime, Endpoint.Address]' --output text | column -t | nl
}

LIST_INSTANCES

#endpoint_array=( $(aws rds describe-db-instances --query 'DBInstances[*][DBInstanceIdentifier, DBInstanceClass, DBInstanceStatus, AvailabilityZone, InstanceCreateTime, Endpoint.Address]' --output text | column -t | nl | awk '{print $7}') )

db_identifier_array=( $(aws rds describe-db-instances --query 'DBInstances[*][DBInstanceIdentifier, DBInstanceClass, DBInstanceStatus, AvailabilityZone, InstanceCreateTime, Endpoint.Address]' --output text | column -t | nl | awk '{print $2}') )

snapshot_array=( $(aws rds describe-db-snapshots --query 'DBSnapshots[*][DBSnapshotIdentifier]' --output text | nl | awk '{print $2}') )

#ENDPOINT=${endpoint_array[$instance_no-1]
echo "Select an option"

echo "1. Create Snapshot of an instance"
echo "2. Restore Instance from a Snapshot"
read option
case $option in
    1) CREATE_SNAPSHOT;;
    2) CREATE_INSTANCE;;
    3) echo $ENDPOINT;;
esac



