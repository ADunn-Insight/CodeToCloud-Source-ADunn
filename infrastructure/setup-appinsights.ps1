$studentsuffix = "add"
$resourcegroupName = "fabmedical-rg-" + $studentsuffix
$workspaceName = "fabmedical-law-"  + $studentsuffix
$location1 = "westus3"
$appInsights = "fabmedical-ai-" + $studentsuffix

az monitor log-analytics workspace create --resource-group $resourcegroupName `
    --workspace-name $workspaceName

az extension add --name application-insights
$ai = az monitor app-insights component create --app $appInsights --location $location1 --kind web -g $resourcegroupName `
    --workspace "/subscriptions/93e5af0e-7bce-4a98-8604-745ed736a73f/resourceGroups/fabmedical-rg-add/providers/Microsoft.OperationalInsights/workspaces/fabmedical-law-add" `
    --application-type web | ConvertFrom-Json

$env:aiInstKey = $ai.instrumentationKey