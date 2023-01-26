@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location

@description('Specifies the name of the storageAccount.')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('Specifies the sku name for the storage account.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Specifies the type of storage account.')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string = 'StorageV2'

@description('Required for storage accounts where kind = BlobStorage. The access tier used for billing.')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Set the minimum TLS version to be permitted on requests to storage.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Allows https traffic only to storage service if set to true.')
param supportsHttpsTrafficOnly bool = true

@description('Allow or disallow public access to all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = true

@description('Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD).')
param allowSharedKeyAccess bool = true

@description('Specifies whether traffic is bypassed by the indicated service.')
@allowed([
  'AzureServices'
  'Logging'
  'Metrics'
  'None'
])
param networkAclsBypass string = 'AzureServices'

@description('Specifies the default action of allow or deny when no other rules match.')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Allow'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: minimumTlsVersion
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    networkAcls: {
      bypass: networkAclsBypass
      defaultAction: networkAclsDefaultAction
    }
  }
}

output storageAccountName string = storageAccountName
output storageAccountResourceGroup string = resourceGroup().name
output location string = location