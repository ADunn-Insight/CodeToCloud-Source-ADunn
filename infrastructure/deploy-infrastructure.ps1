#setup variables fo use within this script
$cosmosDBName = "fabmedical-cdb-" + $studentprefix
$planName = "fabmedical-plan-" + $studentprefix
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
--server-version 4.0

#create the App Service Plan
az appservice plan create --name $planName --resource-group $resourcegroupName --sku S1 --is-linux

#get and configure dbConnection string
$dbKeys = az cosmosdb keys list -n fabmedical-cdb-add -g fabmedical-rg-add --type connection-strings `
    --query "connectionStrings[?description=='Primary MongoDB Connection String'].connectionString"
$manipulate = $dbKeys[1]
$manipulate = $manipulate.Split("""")[1]
$manipulate = $manipulate.Split("?")
$dbConnection = $manipulate[0] + "contentdb?" + $manipulate[1]

#create the WebApp with nginx
az webapp create --resource-group $resourcegroupName `
--plan $planName --name $webappName -i nginx

#configure the webapp settings
az webapp config container set `
--docker-registry-server-password $CR_PAT `
--docker-registry-server-url https://ghcr.io `
--docker-registry-server-user notapplicable `
--multicontainer-config-file ../docker-compose.yml `
--multicontainer-config-type COMPOSE `
--name $webappName `
--resource-group $resourcegroupName `
--enable-app-service-storage true

#set the mongoDB connection
az webapp config appsettings set --resource-group $resourceGroupName `
--name $webappName `
--settings MONGODB_CONNECTION=$dbConnection

#populate the db
docker run -ti -e MONGODB_CONNECTION=$dbConnection ghcr.io/adunn-insight/fabrikam-init