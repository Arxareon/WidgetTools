<# RESOURCES #>

# List of addon namespace directories (inside their specific parent project folders) to copy to
$destinations = Get-Content "$PSScriptRoot\.config\ProjectDirectories.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# Source paths
$sourceWT = Join-Path (Get-Location) "WidgetTools\*"
$sourceToolbox = Join-Path (Get-Location) "WidgetTools\Toolbox"


<# INSTALLATION #>

<# Clear the directories & Copy the files #>

foreach ($destination in $destinations) {
	# Create Widget Tools destination path
	$destinationWT = Join-Path (Split-Path $destination -Parent) "WidgetTools"

	# Clear the Widget Tools directory
	Remove-Item $destinationWT -Include *.* -Recurse -Force

	# Copy WidgetTools to the addon
	if (!(Test-Path -Path $destinationWT)) { New-Item $destinationWT -Type Directory }
	Copy-Item $sourceWT -Destination $destinationWT -Recurse -Force

	# Clear the bundled Toolbox folder in the addon namespace
	Remove-Item (Join-Path $destination "Toolbox") -Recurse -Force

	# Copy the Toolbox to the addon
	if (!(Test-Path -Path $destination)) { New-Item $destination -Type Directory }
	Copy-Item $sourceToolbox -Destination $destination -Recurse -Force
}