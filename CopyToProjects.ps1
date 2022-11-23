<# RESOURCES #>

<# Addons #>

$addons = @()

#List of addon names specifying the folder when inserted into $pathFile to copy to (will also be used to append the addonNameSpace - addon name w/o spaces)
$addons += "Remaining XP"
$addons += "Movement Speed"
$addons += "Better UI Edit Mode"
$addons += "Party Targets"
$addons += "RP Keyboard"


<# INSTALLATION #>

<# Assemble the paths #>

$source = Get-Location

#Path text file (Note: "[addon]" will be replaced with the addon name specified in $addons in the textline within the specified $pathFile.)
$pathFile = Join-Path $source "\.vscode\ProjectsDirectory.txt"

#Destination path to fill
$destination = Get-Content -Path $pathFile
$destination = Join-Path $destination "\[addonNameSpace]\"

<# Copy the files #>

foreach ($addon in $addons) {

	<# Widget Tools #>

	#Fill in the paths
	$sourcePathWT = Join-Path $source "WidgetTools\*"
	$destinationPathWT = $destination -replace "\[addon\]", $addon -replace "\[addonNameSpace\]", "WidgetTools"
	#Copy WidgetTools to the addon
	if (!(Test-Path -Path $destinationPathWT)) { New-Item $destinationPathWT -Type Directory }
	Copy-Item $sourcePathWT -Destination $destinationPathWT -Recurse -Force

	<# WidgetToolbox #>

	#Fill in the paths
	$sourcePathToolbox = Join-Path $source "WidgetTools\WidgetToolbox.lua"
	$destinationPathToolbox = $destination -replace "\[addon\]", $addon -replace "\[addonNameSpace\]", ($addon -replace "\s", "")
	#Copy the Toolbox to the addon
	if (!(Test-Path -Path $destinationPathToolbox)) { New-Item $destinationPathToolbox -Type Directory }
	Copy-Item $sourcePathToolbox -Destination $destinationPathToolbox -Recurse -Force
}