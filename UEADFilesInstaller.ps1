# mostly generated with ai because i hate ps1 scripts

$githubFileUrl = "https://raw.githubusercontent.com/SDOT-real/ExecutorDFiles/main/dfiles/executor.d.luau"

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

$installTo = Resolve-Path "$PSScriptRoot"
Set-Location "$installTo"


# every paths that are used

$vscodeFolder = Maybe-Path $installTo ".vscode"
$settingsPath = Maybe-Path $installTo ".vscode/settings.json"
$dfilesFolder = Maybe-Path $installTo "dfiles"


if ([String]::IsNullOrEmpty($vscodeFolder)) {
	New-Item -Path $installTo -Name ".vscode" -ItemType Directory | Out-Null
	$vscodeFolder = Maybe-Path $installTo ".vscode"
}

if ([String]::IsNullOrEmpty($dfilesFolder)) {
	New-Item -Path $installTo -Name "dfiles" -ItemType Directory | Out-Null
	$dfilesFolder = Maybe-Path $installTo "dfiles"
}

if ([String]::IsNullOrEmpty($settingsPath)) {
	New-Item -Path $vscodeFolder -Name "settings.json" -ItemType File | Out-Null
	$settingsPath = Maybe-Path $vscodeFolder "settings.json"
}
if ((Get-Item $settingsPath).length -eq 0) {
	Set-Content -Path $settingsPath -Value "{}"
}


$destinationPath = Join-Path -Path $dfilesFolder -ChildPath "executor.d.luau"
try {
	Write-Host "Downloading file from GitHub..."
	Invoke-WebRequest -Uri $githubFileUrl -OutFile $destinationPath
}
catch {
	Write-Host "An error occurred while downloading the file: $_"
}


$settingsJson = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json
$settingName = "luau-lsp.types.definitionFiles"
$setting = $settingsJson.$settingName
$dfilesArray = @("dfiles/executor.d.luau")

if ((!$settingsJson.PSObject.Properties.Match($settingName)) -or (!($setting -is [array]))) {
	$settingsJson | Add-Member -MemberType NoteProperty -Name "luau-lsp.types.definitionFiles" -Value $dfilesArray -Force

	$settingsJson | ConvertTo-Json -Depth 100 | Out-File -FilePath $settingsPath -Encoding utf8 -Width 4
}
else {
	if (!($setting -contains "dfiles/executor.d.luau")) {
		$setting += $dfilesArray
		$settingsJson | Add-Member -MemberType NoteProperty -Name "luau-lsp.types.definitionFiles" -Value $setting -Force

		$settingsJson | ConvertTo-Json -Depth 100 | Out-File -FilePath $settingsPath -Encoding utf8 -Width 4
	}
}


Write-Host "Installed/updated!"
Read-Host