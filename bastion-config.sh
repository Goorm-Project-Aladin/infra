#!/bin/bash

# kubectl 설치(Kubernetes 1.23)
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.6/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo "kubectl version: $(eksctl version)"
kubectl version --short --client
echo "kubectl, eksctl installed"

## kubectl 자동완성 기능 설정
# 패키지 설치
sudo yum update
sudo yum install bash-completion -y

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# kubectl(k) alias 설정
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc