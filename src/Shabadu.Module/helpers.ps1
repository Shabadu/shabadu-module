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

<#
This function is based off the env_vars_from_file function in docker-compose https://github.com/docker/compose/blob/master/compose/config/environment.py
#>
function LoadEnvFile
{
	param()
	if(Test-Path ".env")
	{
		$line = ""
		$reader = [System.IO.File]::OpenText(".env")
		try {
			while(($line = $reader.ReadLine()) -ne $null)
			{

			}	
		}
		finally{

		}
	}
}

<#
Based on the get_project_name for the docker-compose git repo https://github.com/docker/compose/blob/master/compose/cli/command.py
#>
function GetProjectName
{
	$composeProjectName = $env:COMPOSE_PROJECT_NAME
	if(-Not $composeProjectName)
	{
		$composeProjectName = (Get-Item ".\").Name
	}
	if(-Not $composeProjectName)
	{
		$composeProjectName = "default"
	}
	return ($composeProjectName.ToLower() -replace "[^-_a-z0-9]*","")
}