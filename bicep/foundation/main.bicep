param vnetName string = 'foundation-vnet'

param vnetAddress string = '10.0.0.0/16'

param subnetName string = 'foundation-subnet'

param subnetAddress string = '10.0.0.0/24'

param location string = resourceGroup().location

param nsgName string = 'foundation-nsg'


module nsgModule 'modules/nsg-baseline.bicep' = {
  name: 'nsgDeployment'
  params: {
    nsgName: nsgName
    location: location
  }
}
module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: vnetName
    vnetAddress: vnetAddress
    subnetName: subnetName
    subnetAddress: subnetAddress
    location: location
  }
}

var kvSuffix = substring(uniqueString(resourceGroup().id), 0, 8)
var keyvaultName = 'kvfd${kvSuffix}'


module keyvaultModule 'modules/keyvault.bicep' = {
  name: 'kvDeployment'
  params: {
    keyvaultName: keyvaultName
    location: location
  }
}

output vnetId string = vnetModule.outputs.vnetId
output subnetId string = vnetModule.outputs.subnetId

output keyvaultId string = keyvaultModule.outputs.keyvaultId
output keyvaultUri string = keyvaultModule.outputs.keyvaultUri
