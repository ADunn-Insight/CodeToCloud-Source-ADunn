#fully automate the creation and deployment of azure resources with one script
& .\deploy-infrastructure.ps1
& .\setup-appinsights.ps1
$insertString = "appInsights.setup(" + $aiInstKey + ");"
(Get-Content ../content-web/app.js) -Replace "appInsights\.setup\(\`"\S+\`"\);", $insertString | Set-Content ../content-web/app.js
git add ../content-web/app.js
git commit -m "added new aiInstKey to app.js"
git push
& .\deploy-container.ps1
