
  AKS_CLUSTER_NAME="dev-eks"
  AKS_RG_NAME="MC_iteration-1_dev-eks_ukwest"

az aks show -n $AKS_CLUSTER_NAME -g $AKS_RG_NAME --query "{oidcIssuerEnabled: oidcIssuerProfile.enabled, workloadIdentityEnabled: workloadIdentityProfile.enabled}"