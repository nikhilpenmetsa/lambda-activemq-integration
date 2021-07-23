#move this to main setup.sh?
#git clone integration repo
#create queue


##Deploy lambda infrastructure
accountId=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .accountId)
s3_deploy_bucket="amazonmqworkshop-sam-deploys-${accountId}"
echo $s3_deploy_bucket
aws s3 mb s3://$s3_deploy_bucket


# brokerId=`aws mq list-brokers | jq '.BrokerSummaries[] | select(.BrokerName=="Broker") | {id:.BrokerId}' | grep "id" | cut -d '"' -f4`
# echo $brokerId
echo "Getting broker ARN..."
brokerArn=`aws mq list-brokers | jq '.BrokerSummaries[] | select(.BrokerName=="Broker") | {id:.BrokerArn}' | grep "id" | cut -d '"' -f4`
echo $brokerArn
echo "Building serverless reciever application..."
sam build
echo "Packaging serverless reciever application..."
sam package --output-template-file packaged.yaml --s3-bucket $s3_deploy_bucket
echo "Deploying serverless reciever application..."
#todo add region logic--region us-west-2
sam deploy --template-file packaged.yaml --stack-name sam-lambda-mq-integration-app-stack --capabilities CAPABILITY_IAM  --parameter-overrides brokerARNParameter=$brokerArn --no-confirm-changeset
#todo..catch and print failure based on return code.
echo "Successfully deployed serverless reciever application..."
