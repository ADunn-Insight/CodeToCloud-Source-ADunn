#fully automate the creation and deployment of azure resources with one script
<#
Create the following:
- resource group: fabmedical-rg-add
- cosmosdb: fabmedical-cdb-add
- app service plan: fabmedical-plan-add
- web app: fabmedical-web-add
Configure the webapp settings
Populate the database
#>
& .\deploy-infrastructure.ps1
<#
Create the following:
- log analytics workspace: fabmedical-law-add
- app insights: fabmedical-ai-add
#>
& .\setup-appinsights.ps1

#configure the app insights instrumentation key and insert it into app.js
$insertString = "appInsights.setup(" + $aiInstKey + ");"
(Get-Content ../content-web/app.js) -Replace "appInsights\.setup\(\`"\S*\`"\);", $insertString | Set-Content ../content-web/app.js

#commit the updated app.js
git add ../content-web/app.js
git commit -m "added new aiInstKey to app.js"
git push
#wait 5 minutes to make sure new container has been pushed to github container registry
Start-Sleep -Seconds 300

#re-deploy the web container to the application
& .\deploy-container.ps1
