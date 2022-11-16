#!/bin/bash

## kubectl 설치(Kubernetes 1.23)
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

## kubectl 자동완성 기능 설정
# 패키지 설치
sudo yum update
sudo yum install bash-completion -y

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# kubectl alias 설정
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

## aws cli 업데이트
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

## Configure aws cli
# https://towardsaws.com/creating-an-eks-cluster-in-aws-with-cloud9-781e21c237cc
# Remove the temporary credentials that Cloud9 is using.
aws cloud9 update-environment --environment-id $C9_PID \
  --managed-credentials-action DISABLE
rm -vf ${HOME}/.aws/credentials

export ACCOUNT_ID=$(aws sts get-caller-identity --output text \
   --query Account)
   
sudo yum -y install jq

# Region, AZ
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export AZS=($(aws ec2 describe-availability-zones --query 'AvailabilityZones[].ZoneName' --output text --region $AWS_REGION))

# Set default region
aws configure set default.region ${AWS_REGION}


# 환경 설정 확인
aws sts get-caller-identity | jq -r '.Arn'

echo "kubectl version: $(eksctl version)"
kubectl version --short --client
echo "kubectl, eksctl installed"