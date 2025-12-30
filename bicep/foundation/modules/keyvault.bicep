param keyvaultName string = 'kv-shared-core'

param location string

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyvaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enablePurgeProtection: true
  }
}


output keyvaultId string = keyvault.id
output keyvaultUri string = keyvault.properties.vaultUri
