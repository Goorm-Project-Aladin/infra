# infra

## How to?

[Creating an EKS Cluster in AWS with Cloud9](https://towardsaws.com/creating-an-eks-cluster-in-aws-with-cloud9-781e21c237cc)

[AWS EKS Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/9c0aa9ab-90a9-44a6-abe1-8dff360ae428/ko-KR/30-setting/100-aws-cloud9)

1. Create Cloud9(Bastion) server

2. Clone repository
    ```bash
    git clone https://github.com/Goorm-Project-Aladin/infra.git && cd infra
    ```

3. Configure Cloud9

    a. EC2 - 인스턴스 - cloud9 인스턴스 선택 - 작업 - 보안 - IAM 역할 수정 - IAM 역할 업데이트

    b. Server settings
    ```bash
    bash ./config-environment.sh
    ```

4. Create EKS Cluster
    ```bash
    cd create-cluster
    bash ./create-cluster.sh {클러스터 이름}
    ```

5. Create ALB Ingress controller
    ```bash
    cd ../alb-ingress-controller
    bash ./create-loadBalancerController.sh
    ```

6. Create EBS CSI Driver
    ```bash
    cd ../aws-ebs-csi-driver
    bash ./aws-ebs-csi-driver.sh
    ```

7. CI/CD

    [CI/CD 파이프라인 구성](https://catalog.us-east-1.prod.workshops.aws/workshops/9c0aa9ab-90a9-44a6-abe1-8dff360ae428/ko-KR/110-cicd/100-cicd)

8. Monitoring(Prometheus + Grafana)
    ```bash
    cd ../monitoring
    bash ./monitoring.sh
    ```