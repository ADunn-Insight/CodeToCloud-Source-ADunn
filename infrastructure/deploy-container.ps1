#this will re-deploy the web container to the application
$studentsuffix = "add"
$resourcegroupName = "fabmedical-rg-" + $studentsuffix
$webappName = "fabmedical-web-" + $studentsuffix

az webapp config container set `
--docker-registry-server-password $CR_PAT `
--docker-registry-server-url https://ghcr.io `
--docker-registry-server-user notapplicable `
--multicontainer-config-file docker-compose.yml `
--multicontainer-config-type COMPOSE `
--name $webappName `
--resource-group $resourcegroupName 