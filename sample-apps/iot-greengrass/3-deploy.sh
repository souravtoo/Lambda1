CORECERTARN=$(cat certs.json | jq -r '.CoreCertificateArn')
DEVICECERTARN=$(cat certs.json | jq -r '.DeviceCertificateArn')
aws cloudformation deploy --template-file template.yml --stack-name greengrass --parameter-overrides CoreCertificateArn=$CORECERTARN DeviceCertificateArn=$DEVICECERTARN LambdaVersionArn=$FUNCTIONARN