param vmName string

param subnetId string

param publicIpId string

param location string

param nsgId string

param tags object = {
  environment: 'prod'
  workload: vmName
}

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'primary'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Static'
          publicIPAddress: empty(publicIpId) ? null : {
            id: publicIpId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
    enableAcceleratedNetworking: true
  }
}

output nicId string = nic.id
output nicName string = nic.name
output privateIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress
