param (
    [string]$region = "Australia East",
    [string]$user = "azureusr",
    [string]$pass = "SuperSecurePassword2020",
    [string]$resourceGroup = $region.Split(" ")[0]+"-"+$region.Split(" ")[1]+"-RG-"+$(Get-Random -Maximum 1000),
    [string]$vmName = "myVM"+"-"+$(Get-Random -Maximum 1000),
    [string]$vmSize = "Standard_B1ls",
    [string]$computerName = "mycomputername",
    [string]$vmDiskName = "myVMDisk"+"-"+$(Get-Random -Maximum 1000),
    [string]$vnetName = $resourceGroup+"-VNet-"+$(Get-Random -Maximum 1000),
    [string]$vnetAddress = "10.0.0.0/16",
    [string]$subnetName = "subnet-"+$(Get-Random -Maximum 1000)+$vnetName,
    [string]$subnetAddress = "10.0.0.0/24",
    [string]$pipName = "myPublicIP-"+(Get-Random -Maximum 1000),
    [string]$nicName = "myNIC-"+$(Get-Random -Maximum 1000)
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
    New-AzResourceGroup -Name $resourceGroup -Location $region
}

# NSG Rule Info
$nsgName = "myNSG"
$SSHRuleName = "myNSGRuleSSH"
$HTTPRuleName = "myNSGRuleHTTP"

$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddress

$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $region -AddressPrefix $vnetAddress -Subnet $subnetConfig

$pip = New-AzPublicIpAddress -Name $pipName -ResourceGroupName $resourceGroup -Location $region -IdleTimeoutInMinutes 4 -AllocationMethod Static

$nsgSSH = New-AzNetworkSecurityRuleConfig -Name $SSHRuleName -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -DestinationAddressPrefix * -SourcePortRange * -DestinationPortRange 22 -Access Allow
$nsgHTTP = New-AzNetworkSecurityRuleConfig -Name $HTTPRuleName -Protocol Tcp -Direction Inbound -Priority 1001 -SourceAddressPrefix * -DestinationAddressPrefix * -SourcePortRange * -DestinationPortRange 80 -Access Allow

$nsg = New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $resourceGroup -Location $region -SecurityRules $nsgSSH,$nsgHTTP

$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup -Location $region -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

$securePassword = ConvertTo-SecureString $pass -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($user,$securePassword)

#$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize | Set-AzVMOperatingSystem -Linux -ComputerName $computerName -Credential $credentials | Set-AzVMSourceImage -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest" | Add-AzVMNetworkInterface -Id $nic.Id

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
$vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Linux -ComputerName $computerName -Credential $credentials
$vmConfig = Set-AzVMSourceImage -VM $vmConfig -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest"
$vmConfig = Set-AzVMOSDisk -VM $vmConfig -Name $vmDiskName -Linux -StorageAccountType Standard_LRS -CreateOption FromImage
$vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

$check = New-AzVM -ResourceGroupName $resourceGroup -Location $region -VM $vmConfig

if($check.IsSuccessStatusCode -eq $true)
{
    Write-Host "***VM Created Successfully***"
}