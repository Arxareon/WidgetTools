<# RESOURCES #>

# Source path
$source = Join-Path (Get-Location) "WidgetTools\*"

# List of addon namespace directories (inside their specific parent project folders) to copy to
$destinations = Get-Content "$PSScriptRoot\.config\ProjectDirectories.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }


<# INSTALLATION #>

<# Clear the directories & Copy the files #>

foreach ($destination in $destinations) {
	# Create Widget Tools destination path
	$destinationPath = Join-Path (Split-Path $destination -Parent) "WidgetTools"

	# Clear the Widget Tools directory
	Remove-Item $destinationPath -Include *.* -Recurse -Force

	# Copy WidgetTools to the addon
	if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
	Copy-Item $source -Destination $destinationPath -Recurse -Force
}