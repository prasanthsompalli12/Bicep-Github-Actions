param resourceName string
param resourceGroupName string

resource azurerm_resource_group 'rg' = {
  name: resourceGroupName
  location: 'eastus' // Specify the desired location for the resource group
}

resource azurerm_kubernetes_cluster 'aks' = {
  name: resourceName
  location: azurerm_resource_group.location
  resource_group_name: azurerm_resource_group.name
  dns_prefix: resourceName
  agent_pool_profiles: [
    {
      name: 'agentpool'
      count: 2 // Specify the desired number of nodes in the agent pool
      vm_size: 'Standard_DS2_v2' // Specify the desired VM size for the nodes
    }
  ]
  service_principal_profile: {
    client_id: '<service-principal-client-id>'
    client_secret: '<service-principal-client-secret>'
  }
  addon_profiles: {
    httpApplicationRouting: {
      enabled: true
    }
  }
}
