function Get-NewFiles
{
    param (
    [string]$Seconds = 60,
    [string]$Path = "C:\"
    )
    $now = Get-Date
    foreach($i in Get-ChildItem -Path $Path -Recurse)
    {
        $elapsed = (New-TimeSpan -Start $i.CreationTime -End $now).TotalSeconds
        if($elapsed -le $Seconds)
        {
            Write-Host $i.FullName
        }
    }
}