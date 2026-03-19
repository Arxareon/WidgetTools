<# RESOURCES #>

# List of addon namespace directories (inside their specific parent project folders) to copy to
$destinations = Get-Content "$PSScriptRoot\.config\ProjectDirectories.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }


<# INSTALLATION #>

foreach ($destination in $destinations) {

	<# Toolbox #>

	$destinationPath = Join-Path $destination "Toolbox"

	# Verify & clear the bundled Toolbox folder in the addon namespace folder
	if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
	Remove-Item $destinationPath -Recurse -Force

	# Copy the Toolbox to the addon
	Copy-Item (Join-Path (Get-Location) "WidgetTools\Toolbox") -Destination $destinationPath -Recurse -Force

	<# Annotations #>

	$destinationPath = Join-Path (Split-Path $destination -Parent) ".annotations\WidgetTools"

	# Verify & clear the Widget Tools annotations folder in the addon project folder
	if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
	Remove-Item $destinationPath -Recurse -Force

	# Copy Widget Tools annotations to the addon
	Copy-Item (Join-Path (Get-Location) ".annotations\WidgetTools") -Destination $destinationPath -Recurse -Force
}