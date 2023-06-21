@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks101clusterpptest'

 

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

 

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = ps

 

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

 

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 3

 

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

 

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'aksmachine'

 

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string ='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6fnCKhMkBj6JRK060x3QSD2UTXtIO+dwEbYOV3ait/sb9gUH0t166VMXQf1KhmrXVMbQOaib+8b9JorchkhL9rlbIzokZ3QG09KlPeWrV9SDYFd4mZzsDyFVT0BwUoeMlQNo5geuagWjEPVGZjhXPzRHZgegXDEbSEIgeGJoeX+ziQ3y9gLvAclIsSic5MG6P4Lpv2WApnVuGx+Xh7V7AXPNGxouYH5Ytt33OzgYA6opU50K5/un8uhUQvLU2LM4tbMixCS3VnyeFz2WkoRY1KWI+vbzzoED6w/tBtsYJSLAP7nAQlp+zF0xKsuZ+r4LuWif3Yf+y/GpfzD9NXMOCcxrH1FFJ3GU7WQ+j4QTBsUwIzAVssKDF4PjVofXIm6a20DPpACd4el8PNY9/CbsNnzOBmEY2dgfGcfj5s8v2S3QVGksq2+fvM3RkugXJ1s53dhVROn7p0Vw2PeY/9ejHtstDlkjHuk4Ilj7IJ26Eg7qoOW2f6Ub7Z65g819qRgE= generated-by-azure'

 

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

 

output controlPlaneFQDN string = aks.properties.fqdn
