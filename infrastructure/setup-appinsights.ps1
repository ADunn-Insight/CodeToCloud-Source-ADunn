#setup variables to use within this script
$workspaceName = "fabmedical-law-"  + $studentsuffix
$appInsights = "fabmedical-ai-" + $studentsuffix
$webappName = "fabmedical-web-" + $studentsuffix

az monitor log-analytics workspace create --resource-group $resourcegroupName `
    --workspace-name $workspaceName

az extension add --name application-insights
$ai = az monitor app-insights component create --app $appInsights --location $location1 --kind web -g $resourcegroupName `
    --workspace "/subscriptions/93e5af0e-7bce-4a98-8604-745ed736a73f/resourceGroups/fabmedical-rg-add/providers/Microsoft.OperationalInsights/workspaces/fabmedical-law-add" `
    --application-type web | ConvertFrom-Json

$global:aiInstKey = $ai.instrumentationKey
$aiConnectionString = $ai.connectionString

#link the newly created app insights to the webapp with default values
az webapp config appsettings set --resource-group $resourceGroupName `
--name $webappName `
--settings APPINSIGHTS_INSTRUMENTATIONKEY=$global:aiInstKey `
    APPINSIGHTS_PROFILERFEATURE_VERSION=1.0.0 `
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION=1.0.0 `
    APPLICATIONINSIGHTS_CONNECTION_STRING=$aiConnectionString `
    ApplicationInsightsAgent_EXTENSION_VERSION=~2 `
    DiagnosticServices_EXTENSION_VERSION=~3 `
    InstrumentationEngine_EXTENSION_VERSION=disabled `
    SnapshotDebugger_EXTENSION_VERSION=disabled `
    XDT_MicrosoftApplicationInsights_BaseExtensions=disabled `
    XDT_MicrosoftApplicationInsights_Mode=recommended `
    XDT_MicrosoftApplicationInsights_PreemptSdk=disabled


