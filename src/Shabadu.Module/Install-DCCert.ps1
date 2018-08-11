. "$PSScriptRoot\helpers.ps1"

<#
# 
#>
function Install-DCCert {
	param (
	)
	VerifyDockerCompose

	if($IsLinux -eq $true -or $IsMacOS -eq $true)
	{
		Write-Error "Install-DCCert currently only supports windows"
		return
	}

	$config = GetConfig
	findAndInstallCerts $config	
}

function findAndInstallCerts {
	param (
		$config
	)

	if($config -and $config.services)
	{
		foreach($skey in $config.services.keys)
		{
			Write-Host "Looking at service" $skey
			$service = $config.services[$skey]
			if($service.labels)
			{
				foreach($lkey in $service.lables.keys)
				{
					if($lkey -and ($lkey.ToString()).StartsWith("org.shabadu.cert"))
					{
						try
						{
							$value = $service.labels[$lkey];
							Import-Certificate -FilePath $value -CertStoreLocation "Cert:\CurrentUser\Root"
						}
						catch
						{
							Write-Error $_
						}
					}
				}
			}
		}
	}
}