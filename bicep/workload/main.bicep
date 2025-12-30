param vmName string
param subnetId string
param publicIpId string
param location string
param nsgId string
param tags object = {
  environment: 'prod'
  workload: vmName
}

module nicModule 'modules/nic.bicep' = {
  name: 'deployNic-${vmName}'
  params: {
    vmName: vmName
    subnetId: subnetId
    publicIpId: publicIpId
    location: location
    nsgId: nsgId
    tags: tags
  }
}

module publicIpModule 'modules/publicIP.bicep' = if (empty(publicIpId)) {
  name: 'deployPublicIp-${vmName}'
  params: {
    publicIpName: '${vmName}-publicip'
    location: location
  }
}

module nsgModule 'modules/nsg-app.bicep' = {
  name: 'deployNsg-${vmName}'
  params: {
    nsgName: '${vmName}-nsg'
    location: location
  }
}

module vmModule 'modules/vm.bicep' = {
  name: 'deployVm-${vmName}'
  params: {
    vmName: vmName
    nicId: nicModule.outputs.nicId
    location: location
    adminPassword: keyvault.outputs.adminPassword
  }
}
