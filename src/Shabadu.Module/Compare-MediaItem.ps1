<#
#>
function Compare-MediaItem {
	param (
		[parameter(mandatory=$true)]
		[string]$YamlFile,
		[parameter(mandatory=$true)]
		[string]$SourceFile
	)

	if((Test-Path $YamlFile) -ne $true)
	{
		Write-Error ("YamlFile '{0}' does not Exist" -f $YamlFile)
		return $null
	}

	if((Test-Path $SourceFile) -ne $true)
	{
		Write-Error ("SourceFile '{0}' does not Exist" -f $SourceFile)
		return $null
	}

	$content = [System.IO.File]::ReadAllText($SourceFile)
	$base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))

	$yaml = [System.IO.File]::ReadAllText($YamlFile)
	$yamlObject = $yaml | ConvertFrom-Yaml
	if($yamlObject.SharedFields)
	{
		$blob = $yamlObject.SharedFields | Where-Object Hint -eq 'Blob'
		if($blob -and $blob.Value -eq $base64)
		{
			return $true;
		}
		else 
		{
			return $false;
		}
	}
	else
	{
		Write-Error "Yaml does not have SharedFields"
		return $null
	}
}