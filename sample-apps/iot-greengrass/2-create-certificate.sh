#!/bin/bash
CORECERTARN=$(aws iot create-keys-and-certificate --certificate-pem-outfile "core.cert.pem" --public-key-outfile "core.public.key" --private-key-outfile "core.private.key" --set-as-active --query 'certificateArn')
CORECERTID=$(echo $CORECERTARN | egrep -ohe '\w{64}')
DEVICECERTARN=$(aws iot create-keys-and-certificate --certificate-pem-outfile "device.cert.pem" --public-key-outfile "device.public.key" --private-key-outfile "device.private.key" --set-as-active --query 'certificateArn')
DEVICECERTID=$(echo $DEVICECERTARN | egrep -ohe '\w{64}')
echo "{\"CoreCertificateArn\": $CORECERTARN,\"CoreCertificateId\": \"$CORECERTID\",\"DeviceCertificateArn\": $DEVICECERTARN,\"DeviceCertificateId\": \"$DEVICECERTID\"}" >> certs.json
