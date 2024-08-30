#!/bin/bash
# Installs esignet-artifactory
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=esignet
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS 

function installing_esignet_artifactory() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Installing esignet-artifactory
  helm -n $NS install esignet-artifactory mosip/artifactory --set image.repository=mosipdev/esignet-artifactory-server --set image.tag=develop --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed esignet-artifactory service
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_esignet_artifactory   # calling function