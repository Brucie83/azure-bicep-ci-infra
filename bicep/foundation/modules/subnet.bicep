param subnetName string
param subnetAddress string 
param vnetName string


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
    addressPrefix: subnetAddress
  }
}


output subnetId string = subnet.id
