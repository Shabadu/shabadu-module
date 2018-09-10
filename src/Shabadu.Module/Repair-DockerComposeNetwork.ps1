. "$PSScriptRoot\helpers.ps1"

function Repair-DockerComposeNetwork {
	param (
	)
	VerifyDockerCompose

	$config = GetConfig
	scanConfigAndRepair $config	
}

function scanConfigAndRepair
{
	param(
		$config
	)

	$projectName = GetProjectName


	if($config -and $config.services -and $config.networks)
	{
		foreach($skey in $config.services.keys)
		{
			Write-Host "Looking at service" $skey
			$service = $config.services[$skey]
			if($service.networks)
			{
				foreach($nkey in $service.networks.keys)
				{
					$network = $service.networks[$nkey]
					if($network -ne $null -and $network -is [System.Collections.DictionaryEntry] -and $network.ContainsKey("ipv4_address"))
					{
						Write-Host "Contains ipv4_address"
					}
				}
			}
			else 
			{
				Write-Host "No networks found for service $skey"
			}
		}
	}

}