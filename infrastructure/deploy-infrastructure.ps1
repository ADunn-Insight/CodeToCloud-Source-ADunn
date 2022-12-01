#setup variables
$studentprefix = "add"
$resourcegroupName = "fabmedical-rg-" + $studentprefix
$cosmosDBName = "fabmedical-cdb-" + $studentprefix
$webappName = "fabmedical-web-" + $studentprefix
$planName = "fabmedical-plan-" + $studentprefix
$location1 = "westeurope"
$location2 = "northeurope"

#create the rss group
az group create -l $location1 -n $resourcegroupName

#create the cosmosDB
#az cosmosdb create --name $cosmosDBName `
#--resource-group $resourcegroupName `
#--locations regionName=$location1 failoverPriority=0 isZoneRedundant=False `
#--locations regionName=$location2 failoverPriority=1 isZoneRedundant=True `
#--enable-multiple-write-locations `
#--kind MongoDB 
#commenting out for now while deciding on a backup region

#create the App Service Plan
az appservice plan create --name $planName --resource-group $resourcegroupName --sku S1 --is-linux

#create the WebApp with nginx
az webapp create --resource-group $resourcegroupName --plan $planName --name $webappName -i nginx