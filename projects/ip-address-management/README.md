# Deploy Windows Server

Find list of images for my region:
```sh
az vm image list   --offer WindowsServer   --publisher MicrosoftWindowsServer   --sku 2025-datacenter-azure-edition   --all   --location eastus2   --output table
```

```sh
cd ip-address-management/templates/vm
az deployment group create \
  --resource-group net-fun-bootcamp \
  --template-file ./template.bicep \
  --parameters @parameters.json
# Verify the deployment
az deployment group list --resource-group net-fun-bootcamp --output table

```
