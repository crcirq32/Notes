#Download Galaxy UCI VM
<#
#download .ps1 version
#iwr https://raw.githubusercontent.com/galaxy3-net/uci-windows-setup/dev/setup.ps1 -UseBasicParsing | iex
echo $?
#Download .sh version
#bash -c "$(curl -s https://raw.githubusercontent.com/galaxy3-net/uci-windows-setup/dev/setup.sh)"
#echo $?
#>

#Web requests
<#
$Response = Invoke-WebRequest -URI https://www.bing.com/search?q=how+many+feet+in+a+mile
$Response.InputFields | Where-Object {
    $_.name -like "* Value*"
} | Select-Object Name, Value

#>