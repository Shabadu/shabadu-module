function VerifyDockerCompose {
	param (
	)
	if(Get-Command 'docker-compose' -errorAction SilentlyContinue){

	}
	else {
		Write-Host "docker-compose not found"
		exit	
	}
}

function GetConfig {
	param (
	)
	
	$source = docker-compose config

	$fixed = [System.String]::Join("`n", $source)

	$dict = $fixed | ConvertFrom-Yaml
	return $dict
}

function Elevate {
	param (
		$Command
	)

	if($IsWindows)
	{
		if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
		{
			Write-Warning "Elevating Permissions"
			Start-Process pwsh -Wait -Verb runAs -ArgumentList "-C",("Set-Location '{0}' ; Import-Module shabadu ; $Command" -f (Get-Location).Path)
			return $true
		}
	}
	elseif($IsLinux)
	{
		Write-Warning "Not elivation implemented for linux"
	}
	elseif($isMacOS)
	{
		Write-Warning "No elivation implemented for Mac OSX"
	}
	else{
		# Old Powershell
		if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
		{
			Write-Warning "Elevating Permissions"
			Start-Process powershell -Wait -Verb runAs -ArgumentList ("Set-Location '{0}' ; Import-Module shabadu ; $Command" -f (Get-Location).Path)
			return $true
		}
	}
	
}