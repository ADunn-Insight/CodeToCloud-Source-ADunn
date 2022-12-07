#fully automate the creation and deployment of azure resources with one script
& .\deploy-infrastructure.ps1
& .\setup-appinsights.ps1
& .\deploy-container.ps1
