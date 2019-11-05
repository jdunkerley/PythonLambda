#!/bin/sh
lambdaName='PythonLambda'
account=`aws sts get-caller-identity --output text --query 'Account'`
region=`aws configure get region`

# Create Role
aws iam create-role --role-name $lambdaName --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}" 

# Create Policy and Attach
aws iam create-policy --policy-name $lambdaName --policy-document "{\"Version\": \"2012-10-17\",\"Statement\": [{\"Effect\": \"Allow\",\"Action\": \"logs:CreateLogGroup\",\"Resource\": \"arn:aws:logs:$region:$account:*\"},{\"Effect\": \"Allow\",\"Action\": [\"logs:CreateLogStream\",\"logs:PutLogEvents\"],\"Resource\": [\"arn:aws:logs:$region:$account:log-group:/aws/lambda/$function:*\"]}]}"
aws iam attach-role-policy --role-name $lambdaName --policy-arn "arn:aws:iam::$account:policy/$lambdaName"

# Zip and publish
zip lambda.zip lambda.py
aws lambda create-function --function-name $lambdaName --runtime "python3.7" --handler "lambda_handler" --zip-file fileb://lambda.zip --role "arn:aws:iam::$account:role/$lambdaName"
rm lambda.zip
