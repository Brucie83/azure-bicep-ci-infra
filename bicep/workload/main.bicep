param vmName string
param subnetId string
param publicIpId string
param location string
param storageNameOut string
param adminUsername string
@secure()
param adminPassword string
param tags object = {
  environment: 'prod'
  workload: vmName
}


module nsgModule 'modules/nsg-app.bicep' = {
  name: 'deployNsg-${vmName}'
  params: {
    nsgName: '${vmName}-nsg'
    location: location
  }
}


module publicIpModule 'modules/publicIP.bicep' = {
  name: 'deployPublicIp-${vmName}'
  params: {
    publicIpName: '${vmName}-publicip'
    location: location
  }
}

module nicModule 'modules/nic.bicep' = {
  name: 'deployNic-${vmName}'
  params: {
    vmName: vmName
    subnetId: subnetId
    publicIpId: empty(publicIpId)
      ? publicIpModule.outputs.publicIpId
      : publicIpId
    location: location
    nsgId: nsgModule.outputs.nsgId
    tags: tags
  }
}


module vmModule 'modules/vm.bicep' = {
  name: 'deployVm-${vmName}'
  params: {
    vmName: vmName
    vmSize: 'Standard_D2s_v3'
    storageNameOut: storageNameOut
    nicId: nicModule.outputs.nicId
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
