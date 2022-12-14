# Remove the temporary credentials that Cloud9 is using.
aws cloud9 update-environment --environment-id $C9_PID \
  --managed-credentials-action DISABLE
rm -vf ${HOME}/.aws/credentials

# AWS CLI 업데이트
sudo pip install --upgrade awscli

## Install another tool
sudo yum install -y jq
sudo yum install -y bash-completion

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
source ~/.bashrc

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

## Cloud9 추가 세팅
# 현재 리전을 기본 값으로 aws cli를 설정
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
    
aws configure set default.region ${AWS_REGION}

# 현재 계정 ID를 환경 변수로 등록
export ACCOUNT_ID=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.accountId')

echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile

# 도커 빌드 시 이미지 크기때문에 용량 부족 이슈가 발생할 수 있으므로 디스크 사이즈 30GB로 증설
wget https://gist.githubusercontent.com/joozero/b48ee68e2174a4f1ead93aaf2b582090/raw/2dda79390a10328df66e5f6162846017c682bef5/resize.sh
sh resize.sh

# Helm 업그레이드
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
