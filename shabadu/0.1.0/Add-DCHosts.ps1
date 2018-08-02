
. "$PSScriptRoot\helpers.ps1"

<#
#>
function Add-DCHosts{
	param(
	)
	VerifyDockerCompose

	if(Elevate "Add-DCHosts")
	{
		# script was elevated
		Get-HostEntry
		return
	}

	try{
		addDCHostsProcess
	}
	catch
	{
		Write-Host "Error"
		Read-Host "Press Any Key to continue"
	}
}

function addDCHostsProcess
{

	$result = @{}

	$config = GetConfig
	if($config.services)
	{
		$keys = $config.services.keys
		foreach($serviceKey in $keys)
		{
			$service = $config.services[$serviceKey];
			if($service)
			{
				Write-Host "Looking at Service", $serviceKey
				if($service.labels)
				{
					$ip = GetIpAddressForService $service
					if($null -ne $ip)
					{
						foreach($lkey in $service.labels.keys)
						{
							if($lkey -and ($lkey.ToString()).StartsWith("org.shabadu.hostname"))
							{
								$result.Add($service.labels[$lkey], $ip)
							}
						}
					}
				}
			}
		}
	}

	$result | Format-Table

	foreach($key in $result.keys)
	{
		$ip = $result[$key];
		# Get the host entry if it exists
		$hostentry = Get-HostEntry $Key -ErrorAction SilentlyContinue

		# Check to see if host entry exists
		if($hostentry)
		{
			# Check to see if host entry equals desired ip
			if($hostentry.Address -ne $ip)
			{
				# Update host entry to desired ip
				Set-HostEntry $key $ip			
				Write-Host ("Set Entry to {0} {1}" -f $key, $ip)
			}
			else {
				Write-Host ("Entry  {0} {1} already exists" -f $key, $ip)
			}
		}
		else
		{
			# Host entry doesn't exist, add with proper ip
			Add-HostEntry $key $ip
			Write-Host ("Added entry {0} {1}" -f $key, $ip)
		}
	}
}

function GetIpAddressForService {
	param (
		$service
	)
	
	if($service -and $service.networks)
	{
		$keys = $service.networks.keys
		foreach($key in $keys)
		{
			$network = $service.networks[$key];
			if($network.ContainsKey("ipv4_address"))
			{
				return $network["ipv4_address"]
			}
		}
	}

	return $null
}