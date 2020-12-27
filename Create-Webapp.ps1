param(
    [string]$webAppName="DemoWebApp"+$(Get-Random -Maximum 1000),
    [string]$Location="Australia East",
    [string]$appServicePlan="DemoWebApps"+$(Get-Random -Maximum 1000),
    [string]$resourceGroup="testrg-"+$(Get-Random -Maximum 1000)
) 

$found = 0
foreach($i in Get-AzResourceGroup | select ResourceGroupName)
{
    if($i.ResourceGroupName -eq $resourceGroup)
    {
        $found = 1
    }
}

if($found -eq 0)
{
    New-AzResourceGroup -Name $resourceGroup -Location $Location
}

#Create an App Service plan in Free tier.  
 New-AzAppServicePlan -Name $AppServicePlan -Location $location -ResourceGroupName $resourceGroup -Tier Free  

#Create a web app.   
New-AzWebApp -Name $webappname -Location $location -AppServicePlan $AppServicePlan -ResourceGroupName $resourceGroup 