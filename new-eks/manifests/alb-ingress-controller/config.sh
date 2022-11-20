#!/bin/bash

## IAM OIDC identity provider 생성
eksctl utils associate-iam-oidc-provider \
    --region ${AWS_REGION} \
    --cluster eks-demo \
    --approve
# 확인
aws eks describe-cluster --name eks-demo --query "cluster.identity.oidc.issuer" --output text


# AWS Load Balancer Controller에 부여할 IAM Policy를 생성하는 작업을 수행
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json


# AWS Load Balancer Controller를 위한 ServiceAccount를 생성
eksctl create iamserviceaccount \
    --cluster eks-demo \
    --namespace kube-system \
    --name aws-load-balancer-controller \
    --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --approve


## 클러스터에 컨트롤러 추가하기
# 먼저, 인증서 구성을 웹훅에 삽입할 수 있도록 cert-manager 를 설치합니다. Cert-manager는 쿠버네티스 클러스터 내에서 TLS인증서를 자동으로 프로비저닝 및 관리하는 오픈 소스입니다.
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

# AWS Load Balancer controller 파일을 배포합니다.
kubectl apply -f v2_4_4_full.yaml

# 확인
kubectl get deployment -n kube-system aws-load-balancer-controller
