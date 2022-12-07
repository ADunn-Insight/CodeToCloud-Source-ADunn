#setup variables
$studentprefix = "add"
$resourcegroupName = "fabmedical-rg-" + $studentprefix
$cosmosDBName = "fabmedical-cdb-" + $studentprefix
$webappName = "fabmedical-web-" + $studentprefix
$planName = "fabmedical-plan-" + $studentprefix
$location1 = "westus3"
$location2 = "eastus"
$dbConnection = ""
$manipulate = ""
$dbKeys = ""

#create the rss group
az group create -l $location1 -n $resourcegroupName

#create the cosmosDB
az cosmosdb create --name $cosmosDBName `
--resource-group $resourcegroupName `
--locations regionName=$location1 failoverPriority=0 isZoneRedundant=False `
--locations regionName=$location2 failoverPriority=1 isZoneRedundant=True `
--enable-multiple-write-locations `
--kind MongoDB `
--server-version 4.0 `

#create the App Service Plan
az appservice plan create --name $planName --resource-group $resourcegroupName --sku S1 --is-linux

#get and configure dbConnection string
$dbKeys = az cosmosdb keys list -n $cosmosDBName -g $resourceGroupName --type connection-strings
$manipulate = $dbKeys[3]
$manipulate.Trim()
$manipulate = $manipulate.Split("""")[3]
$manipulate = $manipulate.Split("?")
$dbConnection = $manipulate[0] + "contentdb?" + $manipulate[1]

#create the WebApp with nginx
az webapp create --resource-group $resourcegroupName `
--plan $planName --name $webappName -i nginx `
--settings WEBSITES_ENABLE_APP_SERVICE_STORAGE=true MONGODB_CONNECTION=$dbConnection

#configure the webapp settings
az webapp config container set `
--docker-registry-server-password $my_pat `
--docker-registry-server-url https://ghcr.io `
--docker-registry-server-user notapplicable `
--multicontainer-config-file docker-compose.yml `
--multicontainer-config-type COMPOSE `
--name $webappName `
--resource-group $resourcegroupName 