# infra

## How to?

1. Create Cloud9(Bastion) server

2. Clone repository
    ```bash
    git clone https://github.com/Goorm-Project-Aladin/infra.git && cd infra
    ```

3. Configure Bastion server
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