#!/bin/bash

# Add console credential
rolearn=$(aws cloud9 describe-environment-memberships --environment-id=$C9_PID | jq -r '.memberships[].userArn')

echo ${rolearn}

# TODO: echo에서 assumed-role이 있으면 아래 두 줄 실행하는 if문 작성
assumedrolename=$(echo ${rolearn} | awk -F/ '{print $(NF-1)}')
rolearn=$(aws iam get-role --role-name ${assumedrolename} --query Role.Arn --output text) 

eksctl create iamidentitymapping --cluster eks-demo --arn ${rolearn} --group system:masters --username admin

kubectl describe configmap -n kube-system aws-auth
