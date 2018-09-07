. "$PSScriptRoot\helpers.ps1"

function Repair-DockerComposeNetwork {
	param (
	)
	VerifyDockerCompose

	$config = GetConfig
	findAndInstallCerts $config	
}

function scanConfigAndRepair
{
	param(
		$config
	)


	if($config -and $config.services)
	{
		foreach($skey in $config.services.keys)
		{
			Write-Host "Looking at service" $skey
			$service = $config.services[$skey]
			if($service.networks)
			{
				$containerId = docker container
			}
			else 
			{
				Write-Host "No networks found for service $skey"
			}
		}
	}

}