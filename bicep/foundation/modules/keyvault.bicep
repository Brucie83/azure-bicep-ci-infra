param keyvaultName string = 'kv-foundation-dev-${uniqueString(resourceGroup().id)}'
param location string

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyvaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 7
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
}

output keyvaultId string = keyvault.id
output keyvaultUri string = keyvault.properties.vaultUri
