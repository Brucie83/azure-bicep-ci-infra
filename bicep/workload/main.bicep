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
module nicModule 'modules/nic.bicep' = {
  name: 'deployNic-${vmName}'
  params: {
    vmName: vmName
    subnetId: subnetId
    publicIpId: ''
    location: location
    nsgId: nsgModule.outputs.nsgId
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

module vmModule 'modules/vm.bicep' = {
  name: 'deployVm-${vmName}'
  params: {
    vmName: vmName
    vmSize: 'Standard_DS2_v2'
    storageNameOut: storageNameOut
    nicId: nicModule.outputs.nicId
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
