#move this to main setup.sh
#git clone integration repo
#create queue


brokerId=`aws mq list-brokers | jq '.BrokerSummaries[] | select(.BrokerName=="Broker") | {id:.BrokerId}' | grep "id" | cut -d '"' -f4`
echo $brokerId
echo "Getting broker ARN..."
brokerArn=`aws mq list-brokers | jq '.BrokerSummaries[] | select(.BrokerName=="Broker") | {id:.BrokerArn}' | grep "id" | cut -d '"' -f4`
echo $brokerArn
echo "Building serverless reciever application..."
sam build
echo "Deploying serverless reciever application..."
#todo add region logic--region us-west-2
sam deploy --stack-name sam-lambda-mq-integration-app2-stack --capabilities CAPABILITY_IAM  --parameter-overrides brokerARNParameter=$brokerArn --no-confirm-changeset
#todo..catch and print failure based on return code.
echo "Successfully deployed serverless reciever application..."
