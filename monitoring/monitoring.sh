#!/bin/bash

# https://may9noy.tistory.com/303
# Add helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update

# Deploy prometheus & grafana by helm
kubectl create ns monitoring
helm install prometheus prometheus-community/prometheus -f values-prometheus.yaml -n monitoring
helm install grafana grafana/grafana -f values-grafana.yaml -n monitoring


# 배포 확인
kubectl get pod,svc -n monitoring