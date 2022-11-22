#!/bin/bash

echo "export CLUSTER_NAME=$1" >> ~/.bashrc
envsubst < eks-cluster.yaml > $CLUSTER_NAME.yaml
# EKS 클러스터 생성
eksctl create cluster -f $CLUSTER_NAME.yaml

# 콘솔 Credential을 클러스터에 추가
rolearn=$(aws cloud9 describe-environment-memberships --environment-id=$C9_PID | jq -r '.memberships[].userArn')
if [[ "$rolearn" =~ "assumed-role" ]]; then
    assumedrolename=$(echo ${rolearn} | awk -F/ '{print $(NF-1)}')
    rolearn=$(aws iam get-role --role-name ${assumedrolename} --query Role.Arn --output text)
fi

# identity 맵핑
eksctl create iamidentitymapping --cluster $CLUSTER_NAME --arn ${rolearn} --group system:masters --username admin
# 관련 정보 확인
kubectl describe configmap -n kube-system aws-auth

echo "***************************************************"
echo "*Open another terminal & Preceed next process!!!!!*"
echo "***************************************************"