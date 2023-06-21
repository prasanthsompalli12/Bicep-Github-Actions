param location string = 'eastus'
param clusterName string = 'myAKSClusterPPhb'
param nodeCount int = 2
param nodeVMSize string = 'Standard_D2s_v3'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${clusterName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${clusterName}-subnet'
  parent: vnet
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: clusterName
  location: location
  properties: {
    dnsPrefix: clusterName
    kubernetesVersion: '1.22.2'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: nodeCount
        vmSize: nodeVMSize
        osDiskSizeGB: 30
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.245.0.0/16'
      dnsServiceIP: '10.245.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
    enableRBAC: true
  }
}
