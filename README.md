# infra

## How to?

1. Create Cloud9(Bastion) server

2. Disable AWS Settings - Credentials

    ![Config Cloud9](https://github.com/Goorm-Project-Aladin/infra/blob/main/images/1.png)

3. Clone repository
    ```bash
    git clone https://github.com/Goorm-Project-Aladin/infra.git && cd infra
    ```

4. Configure Bastion server
    ```bash
    aws configure

    bash ./bastion-config.sh
    ```

5. Install helm
    ```bash
    bash ./helm-install.sh
    ```

6. Create EKS Cluster
    ```bash
    eksctl create cluster -f aladinEKS.yaml
    ```

7. Create RDS service
    ```bash
    bash ./awscli_rds.sh
    ```