#!/bin/bash

set -euxo pipefail

INS_ID_1=$(terraform output --raw ec2_instance_id)
VOL_ID_1=$(terraform output --raw ec2_instance_volume_id)

echo "TARGET INSTANCE ID: $INS_ID_1"
echo "TARGET VOLUME ID: $VOL_ID_1"

# stop instance and create snapshot
aws ec2 stop-instances --instance-ids ${INS_ID_1} &> /dev/null && aws ec2 wait instance-stopped --instance-ids ${INS_ID_1}
# SNAPSHOT_ID=$(aws ec2 create-snapshot --volume-id $VOL_ID --tag-specifications 'ResourceType=snapshot,Tags=[{Key=name,Value=toyamagu}]' | jq -r ".SnapshotId")
# aws ec2 wait snapshot-completed --snapshot-ids ${SNAPSHOT_ID}

# change instance type
terraform apply -auto-approve -var-file="2nd.tfvars" -replace="aws_instance.this" 

INS_ID_2=$(terraform output --raw ec2_instance_id)
VOL_ID_2=$(terraform output --raw ec2_instance_volume_id)

# stop instance
aws ec2 stop-instances --instance-ids ${INS_ID_2} &> /dev/null && aws ec2 wait instance-stopped --instance-ids ${INS_ID_2}

# detach volume2
aws ec2 detach-volume --volume-id ${VOL_ID_2}
aws ec2 wait volume-available --volume-ids ${VOL_ID_2}
aws ec2 delete-volume --volume-id ${VOL_ID_2}

# attach volume1
aws ec2 attach-volume --volume-id ${VOL_ID_1} --instance-id ${INS_ID_2} --device /dev/xvda
aws ec2 wait volume-in-use --volume-ids ${VOL_ID_1}

# refresh terraform state
terraform apply -auto-approve -refresh-only -var-file="2nd.tfvars"

