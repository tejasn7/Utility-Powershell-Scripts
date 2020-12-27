foreach($i in Import-Csv ./users.csv -Delimiter ",")
{
    $displayName = $i.DisplayName
    $initial = $displayName.Split(" ")[0][0]
    $upn = $initial + $displayName.Split(" ")[1]
    $country = $i.Country
    $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $passwordProfile.Password = "Winter@123"
    # $domainName = [string](Get-AzureADDomain).Name
    $d = Get-AzureADDomain | select Name
    $domainName = $d[1].Name
    $mailNickName = $displayName.Split(" ")[0]
    New-AzureADUser -DisplayName $displayName -PasswordProfile $passwordProfile -AccountEnabled $true -UserPrincipalName "$upn@$domainName" -MailNickName $mailNickName -Country $country
}