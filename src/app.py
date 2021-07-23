import json
import base64

def lambda_handler(event, context):
    
    # TODO implement
    #print(event)
    #print(context.aws_request_id)
    for message in event["messages"]:
        queueName = message["destination"]["physicalName"]
        #print("queueName", queueName)
        base64messageBody = message["data"]
        #print(base64messageBody)
        plainMessageBody = base64.b64decode(base64messageBody).decode("utf-8")
        #print(plainMessageBody)
        #print(context.function_name )
        print("Lambda ", context.function_name, " Receiver: received ", plainMessageBody)

# 16.07.2021 14:50:23.918 - Receiver: received '[queue://workshop.queueA] [Sender-1] Message number 456'
#   Lambda  myMQSubsciber2  Receiver: received  b'[queue://myQueue] [Sender-1] Message number 12'
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda v2!')
    }
