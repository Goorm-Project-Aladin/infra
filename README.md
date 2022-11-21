# infra

## How to?

[Creating an EKS Cluster in AWS with Cloud9](https://towardsaws.com/creating-an-eks-cluster-in-aws-with-cloud9-781e21c237cc)

[AWS EKS Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/9c0aa9ab-90a9-44a6-abe1-8dff360ae428/ko-KR/30-setting/100-aws-cloud9)

1. Create Cloud9(Bastion) server

2. Clone repository
    ```bash
    git clone https://github.com/Goorm-Project-Aladin/infra.git && cd infra
    ```

2. Configure Cloud9

    b. EC2 - 인스턴스 - cloud9 인스턴스 선택 - 작업 - 보안 - IAM 역할 수정 - IAM 역할 업데이트

    c. Server settings
    ```bash
    bash ./bastion-config.sh
    ```

4. Install helm
    ```bash
    bash ./helm-install.sh
    ```

5. Create EKS Cluster
    ```bash
    eksctl create cluster -f aladinEKS.yaml
    ```

6. Create RDS service
    ```bash
    bash ./awscli_rds.sh
    ```