param (
    [string]$vnet = "",
    [string]$AddressPrefix = "10.0.1.0/24",
    [string]$subnetName = "new-subnet-"+$(Get-Random -Maximum 1000)
)

if($vnet -eq "")
{
    Write-Host "Please specify vnet name"
    exit
}

$virtualNetwork = Get-AzVirtualNetwork -Name $vnet
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork -AddressPrefix $AddressPrefix
$virtualNetwork | Set-AzVirtualNetwork