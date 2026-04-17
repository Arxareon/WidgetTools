<# RESOURCES #>

# List of addon namespace directories (inside their specific parent project folders) to copy to
$addons = Get-Content "$PSScriptRoot\.config\ProjectDirectories.txt" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# Toolbox
$toolboxSource = Join-Path (Get-Location) ".toolbox"
$toolboxVersion = (Select-String (Join-Path $toolboxSource "Toolbox.toc") -Pattern "^## Version:").Line.Split(":")[1].Trim()
$toolboxName = "WidgetToolbox_$toolboxVersion"
$toolbox = Join-Path (Get-Location) $toolboxName


<# INSTALLATION #>

# Update the TOC
$widgetToolsTOC = Join-Path (Get-Location) "WidgetTools\WidgetTools.toc"
(Get-Content $widgetToolsTOC -Raw) -replace "X-WidgetTools-ToolboxVersion:.*", "X-WidgetTools-ToolboxVersion: $toolboxVersion" | Set-Content $widgetToolsTOC -NoNewline

<# Toolbox #>

# Create the install copy
Get-ChildItem (Get-Location) -Directory -Filter "WidgetToolbox_*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item $toolboxSource -Destination $toolbox -Recurse -Force

# Rename the TOC
$toolboxTOC = Join-Path $toolbox "Toolbox.toc"
Rename-Item $toolboxTOC "$toolboxName.toc" -Force

<# Addon Projects #>

foreach ($addon in $addons) {
	if (-not (Test-Path $addon)) { continue }

	<# Toolbox #>

	# Version
	$addonTOC = (Get-ChildItem $addon -Filter "*.toc").FullName
	(Get-Content $addonTOC -Raw) -replace "X-WidgetTools-ToolboxVersion:.*", "X-WidgetTools-ToolboxVersion: $toolboxVersion" | Set-Content $addonTOC -NoNewline

	# Loader
	Copy-Item (Join-Path (Get-Location) "WidgetTools\Toolbox.lua") -Destination $addon -Force

	# Addon
	$projectRoot = Split-Path $addon -Parent
	Get-ChildItem $projectRoot -Directory -Filter "WidgetToolbox_*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
	Copy-Item $toolbox -Destination (Join-Path $projectRoot $toolboxName) -Recurse -Force

	<# Annotations #>

	$annotationsPath = Join-Path (Split-Path $addon -Parent) ".annotations\WidgetTools"
	Remove-Item $annotationsPath -Recurse -Force -ErrorAction SilentlyContinue
	Copy-Item (Join-Path (Get-Location) ".annotations") -Destination $annotationsPath -Recurse -Force
}