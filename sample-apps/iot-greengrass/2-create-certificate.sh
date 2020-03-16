#!/bin/bash
CORECERTARN=$(aws iot create-keys-and-certificate --certificate-pem-outfile "core.cert.pem" --public-key-outfile "core.public.key" --private-key-outfile "core.private.key" --set-as-active --query 'certificateArn')
DEVICECERTARN=$(aws iot create-keys-and-certificate --certificate-pem-outfile "device.cert.pem" --public-key-outfile "device.public.key" --private-key-outfile "device.private.key" --set-as-active --query 'certificateArn')
echo "{\"CoreCertificateArn\": $CORECERTARN,\"DeviceCertificateArn\": $DEVICECERTARN}" >> certs.json

CORECERTID=$(echo $CORECERTARN | egrep -ohe '\w{64}')
DEVICECERTID=$(echo $DEVICECERTARN | egrep -ohe '\w{64}')
CORECERTIDSHORT=$(cat certs.json | jq -r '.CoreCertificateArn | split("/")[1][0:7]')
mkdir core-$CORECERTIDSHORT
DEVICECERTIDSHORT=$(cat certs.json | jq -r '.DeviceCertificateArn | split("/")[1][0:7]')
mkdir core-$CORECERTIDSHORT

