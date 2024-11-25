# mostly generated with ai because i hate ps1 scripts

function Maybe-Path {
	# literally stole that from a custom hud for tf2 and added smth
	param(
		[string]$Path,
		[string]$ChildPath
	)
	if ([String]::IsNullOrEmpty($Path) -or [String]::IsNullOrEmpty($ChildPath)) {
		return $null
	}
	$joined = Join-Path $Path $ChildPath
	if (Test-Path $joined) {
		return Resolve-Path $joined
	}
	return $null
}

$installer = Resolve-Path "$PSScriptRoot"
Set-Location "$installer"

function Merge-JsonContent {
	param (
		[Parameter(Mandatory = $true)]
		[object]$Json1,

		[Parameter(Mandatory = $true)]
		[object]$Json2
	)

	# Convert JSON strings to PowerShell objects if they are strings
	if ($Json1 -is [string]) {
		$Json1 = $Json1 | ConvertFrom-Json
	}

	if ($Json2 -is [string]) {
		$Json2 = $Json2 | ConvertFrom-Json
	}

	# Iterate through properties of the second JSON object
	foreach ($property in $Json2.PSObject.Properties) {
		if ($Json1.PSObject.Properties[$property.Name]) {
			# If property already exists in the first JSON, handle based on type
			if ($Json1.$($property.Name) -is [hashtable]) {
				# If both are nested objects (dictionaries), merge them recursively
				$Json1.$($property.Name) = Merge-JsonContent -Json1 $Json1.$($property.Name) -Json2 $Json2.$($property.Name)
			}
			elseif ($Json1.$($property.Name) -is [System.Collections.IEnumerable] -and -not ($Json1.$($property.Name) -is [string])) {
				# If both are arrays, combine arrays without duplication
				$Json1.$($property.Name) += $property.Value
				$Json1.$($property.Name) = $Json1.$($property.Name) | Select-Object -Unique
			}
			else {
				# If the property type conflicts or is not an object/array, overwrite the value
				$Json1.$($property.Name) = $property.Value
			}
		}
		else {
			# If the property doesn't exist in the first JSON, add it
			$Json1.PSObject.Properties.Add($property)
		}
	}

	return $Json1
}


# every paths that are used

$installTo = Split-Path $PSScriptRoot

$vscodeFolder = Maybe-Path $installTo ".vscode"
$settingsPath = Maybe-Path $installTo ".vscode/settings.json"
$defFileSettingPath = Maybe-Path $installer "settings.json"
$dfilesPath = Maybe-Path $installer "dfiles"


if ([String]::IsNullOrEmpty($vscodeFolder)) {
	New-Item -Path $installTo -Name ".vscode" -ItemType Directory | Out-Null
	$vscodeFolder = Maybe-Path $installTo ".vscode"
}

if ([String]::IsNullOrEmpty($settingsPath)) {
	New-Item -Path $vscodeFolder -Name "settings.json" -ItemType File | Out-Null
	$settingsPath = Maybe-Path $vscodeFolder "settings.json"
}
if ((Get-Item $settingsPath).length -eq 0) {
	Set-Content -Path $settingsPath -Value "{}"
} 

$originalJson = Get-Content -Path $settingsPath | ConvertFrom-Json
$settingJson = Get-Content -Path $defFileSettingPath | ConvertFrom-Json

$mergedJson = Merge-JsonContent -Json1 $originalJson -Json2 $settingJson
$mergedJson | ConvertTo-Json -Depth 100 | Out-File -FilePath $settingsPath -Encoding utf8

Copy-Item $dfilesPath -Destination $installTo -Recurse -Force

Write-Host "Installed!"
Read-Host