aws eks describe-cluster \
  --name  \
  --query "cluster.identity.oidc.issuer" \
  --output text