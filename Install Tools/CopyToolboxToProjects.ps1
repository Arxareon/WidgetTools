<# RESOURCES #>

# Source path
$source = Join-Path (Get-Location) "WidgetTools\Toolbox"

# List of addon namespace directories (inside their specific parent project folders) to copy to
$destinations = Get-Content "$PSScriptRoot\.config\ProjectDirectories.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }


<# INSTALLATION #>

<# Clear the directories & Copy the files #>

foreach ($destination in $destinations) {
	# Clear the bundled Toolbox folder in the addon namespace
	Remove-Item (Join-Path $destination "Toolbox") -Recurse -Force

	# Copy the Toolbox to the addon
	if (!(Test-Path -Path $destination)) { New-Item $destination -Type Directory }
	Copy-Item $source -Destination $destination -Recurse -Force
}