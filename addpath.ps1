param (
[string]$prog,
[string]$path = "C:\",
[string]$type = "user"
)

$userpath = [System.Environment]::GetEnvironmentVariable("path",[System.EnvironmentVariableTarget]::User)

if($type -eq "user" -or $type -eq "USER")
{
    $i = Get-ChildItem -Path $path -Filter $prog -Recurse -Force -ErrorAction SilentlyContinue
    if($i -eq $null)
    {
        Write-Host "Executable not found in the path mentioned"
        exit
    }
    Write-Host "Executable found at following locations. Adding only first instance."
    foreach($j in $i | select Directory)
    {
        Write-Host $j.Directory
    }
    $x = ";"+$i[0].Directory
    Write-Host "$x"
    [System.Environment]::SetEnvironmentVariable("path",[System.Environment]::GetEnvironmentVariable("path",[System.EnvironmentVariableTarget]::User)+"$x",[System.EnvironmentVariableTarget]::User)
}
elseif($type -eq "system" -or $type -eq "SYSTEM")
{
    $i = Get-ChildItem -Path $path -Filter $prog -Recurse -Force -ErrorAction SilentlyContinue
    if($i -eq $null)
    {
        Write-Host "Executable not found in the path mentioned"
        exit
    }
    Write-Host "Executable found at following locations. Adding only first instance."
    foreach($j in $i | select Directory)
    {
        Write-Host $j.Directory
    }
    $x = ";"+$i[0].Directory
    Write-Host "$x"
    [System.Environment]::SetEnvironmentVariable("path",[System.Environment]::GetEnvironmentVariable("path",[System.EnvironmentVariableTarget]::Machine+"$x",[System.EnvironmentVariableTarget]::Machine)
}
else
{
    Write-Output "Specify USER Path or SYSTEM path"
}