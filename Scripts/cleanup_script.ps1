#TODO: enable running scripts

#Get-Files based on length
<#
#Get-ChildItem c:\ -r| sort -descending -property length | select -first 10 name, Length -ErrorAction SilentlyContinue 

#Files larger than 1MB with pathname TODO: add size to output
#Get-ChildItem c:\ -r -ErrorAction SilentlyContinue –Force |sort -descending -property length | select -first 10 name, DirectoryName, @{Name="MB";Expression={[Math]::round($_.length / 1MB, 2)}}

Gridview TODO: add date to output

Get-ChildItem c:\ -r|sort -descending -property length | select -first 10 name, DirectoryName, @{Name="MB";Expression={[Math]::round($_.length / 1MB, 2)}} | Out-GridView
#>


# Delete files in G:\Downloads older than 6 months.
<#

$Folder = "C:\Users\admin_2\AppData\Local\Temp"

#Delete files older than 6 months
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-100)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File C:\log\deletedlog.txt -Append
}

#Delete empty folders and subfolders
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {$_.PsIsContainer -eq $True} |
? {$_.getfiles().count -eq 0} |
ForEach-Object {
    $_ | del -Force
    $_.FullName | Out-File C:\log\deletedlog.txt -Append
}
#>

#Information on specific files
<#

#Info on a specific item:
get-itemproperty $ITEMNAME | format-list

#Get the value name and data of a registry entry in a registry subkey
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name "ProgramFilesDir"

#Get the value names and data of registry entries in a registry key
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine

#>
