# 헬름 차트의 저장소 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 네임스페이스 생성
kubectl create ns monitoring

# kube-prometheus-stack 설치 
helm install prometheus-stack prometheus-community/kube-prometheus-stack -f ./custom.yaml -n monitoring

# 설치 확인 
kubectl get pods -l "release=prometheus-stack" -n monitoring
helm get values prometheus-stack -n monitoring
kubectl get pvc -n monitoring
kubectl get pv -n monitoring

# kube-prometheus-stack 업데이트 하기
helm upgrade prometheus-stack prometheus-community/kube-prometheus-stack -f ./custom.yaml -n monitoring

# kube-prometheus-stack 삭제하기
helm uninstall prometheus-stack -n monitoring