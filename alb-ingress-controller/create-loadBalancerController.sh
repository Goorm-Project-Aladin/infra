#!/bin/bash

OIDC_provider_URL=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | awk -F "/" '{ print $5 }')
CHECK_OIDC=$(aws iam list-open-id-connect-providers | grep $OIDC_provider_URL)
if [[ -z ${CHECK_OIDC} ]]; then
    eksctl utils associate-iam-oidc-provider \
        --region ${AWS_REGION} \
        --cluster $CLUSTER_NAME \
        --approve
fi

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json

# AWS Load Balancer Controller를 위한 ServiceAccount를 생성
eksctl create iamserviceaccount \
    --cluster $CLUSTER_NAME \
    --namespace kube-system \
    --name aws-load-balancer-controller \
    --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --approve

## 클러스터에 컨트롤러 추가
# 인증서 구성을 웹훅에 삽입할 수 있도록 cert-manager를 설치
# cert-manager: 쿠버네티스 내에서 TLS 인증서를 자동으로 프로비저닝 및 관리하는 오픈소스
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

# 로드밸런서 YAML 파일 다운로드
wget https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml
# YAML 파일 편집
sed -i 's/your-cluster-name/$CLUSTER_NAME/g' v2_4_4_full.yaml
sed '480,488d' v2_4_4_full.yaml

kubectl apply -f v2_4_4_full.yaml

