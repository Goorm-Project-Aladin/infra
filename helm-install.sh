#!/bin/bash

## Helm 설치
curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
chmod 700 get_helm.sh
./get_helm.sh