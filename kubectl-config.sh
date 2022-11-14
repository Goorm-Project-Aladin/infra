#!/bin/bash

# 패키지 설치
sudo yum update
sudo yum install bash-completion -y

# 자동 완성 스크립트 결과 저장
echo 'source <(kubectl completion bash)' >>~/.bashrc

# kubectl(k) alias 설정
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
