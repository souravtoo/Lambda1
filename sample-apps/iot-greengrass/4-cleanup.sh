#!/bin/bash
set -eo pipefail
aws cloudformation delete-stack --stack-name greengrass
echo "Deleted function stack"
if [ -f bucket-name.txt ]; then
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    while true; do
        read -p "Delete deployment artifacts and bucket ($ARTIFACT_BUCKET)?" response
        case $response in
            [Yy]* ) aws s3 rb --force s3://$ARTIFACT_BUCKET; rm bucket-name.txt; break;;
            [Nn]* ) break;;
            * ) echo "Response must start with y or n.";;
        esac
    done
fi
if [ -f certs.json ]; then
    CORECERTID=$(cat certs.json | jq -r '.CoreCertificateArn | split("/")[1]')
    DEVICECERTID=$(cat certs.json | jq -r '.DeviceCertificateArn | split("/")[1]')
    while true; do
        read -p "Delete certs?" response
        case $response in
            [Yy]* ) aws iot update-certificate --certificate-id $CORECERTID --new-status INACTIVE && aws iot update-certificate --certificate-id $DEVICECERTID --new-status INACTIVE && aws iot delete-certificate --certificate-id $CORECERTID && aws iot delete-certificate --certificate-id $DEVICECERTID && rm core.* device.*; break;;
            [Nn]* ) break;;
            * ) echo "Response must start with y or n.";;
        esac
    done
fi

rm -f out.yml out.json
rm -rf function/node_modules function/package-lock.json
