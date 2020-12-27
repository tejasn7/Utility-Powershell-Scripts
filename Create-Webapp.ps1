#Defined the Web Application Name and location  
$webappname="DemoWebAppSbeeh1"  
$location="West Europe"  
$AppServicePlan="DemoWebApps"  

#Create a resource group.  
New-AzureRmResourceGroup -Name DemoResourceGroup -Location $location  

#Create an App Service plan in Free tier.  
 New-AzureRmAppServicePlan -Name $AppServicePlan -Location $location -ResourceGroupName DemoResourceGroup -Tier Free  

#Create a web app.   
New-AzureRmWebApp -Name $webappname -Location $location -AppServicePlan $AppServicePlan -ResourceGroupName DemoResourceGroup 