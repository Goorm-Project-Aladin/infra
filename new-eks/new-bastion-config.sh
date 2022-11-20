#!/bin/bash

## Cloud9 설정
# Remove the temporary credentials that Cloud9 is using.
aws cloud9 update-environment --environment-id $C9_PID \
  --managed-credentials-action DISABLE
rm -vf ${HOME}/.aws/credentials

## AWS CLI 업데이트
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
export PATH=/usr/local/bin:$PATH
source ~/.bash_profile

## kubectl 설치(Kubernetes 1.23)
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# kubectl alias 설정
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

## Install another tool
sudo yum install -y jq
sudo yum install -y bash-completion

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

## kubectl 자동완성 기능 설정
# 패키지 설치
sudo yum update
sudo yum install bash-completion -y

## Cloud9 추가 세팅
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
    
aws configure set default.region ${AWS_REGION}

aws configure get default.region

export ACCOUNT_ID=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.accountId')

echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile

## 도커 빌드 시 이미지 크기때문에 용량 부족 이슈가 발생할 수 있으므로 디스크 사이즈 30GB로 증설
wget https://gist.githubusercontent.com/joozero/b48ee68e2174a4f1ead93aaf2b582090/raw/2dda79390a10328df66e5f6162846017c682bef5/resize.sh
sh resize.sh
# 볼륨 크기 확인
df -h


# 환경 설정 확인
aws sts get-caller-identity | jq -r '.Arn'

echo "kubectl version: $(eksctl version)"
kubectl version --short --client
echo "kubectl, eksctl installed"