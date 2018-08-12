function Update-MediaItem {
	param (
		[parameter(mandatory=$true)]
		[string]$YamlFile,
		[parameter(mandatory=$true)]
		[string]$SourceFile
	)

	if((Test-Path $YamlFile) -ne $true)
	{
		Write-Error ("YamlFile '{0}' does not Exist" -f $YamlFile)
		return $false
	}

	if((Test-Path $SourceFile) -ne $true)
	{
		Write-Error ("SourceFile '{0}' does not Exist" -f $SourceFile)
		return $false
	}

	$content = [System.IO.File]::ReadAllText($SourceFile)
	$base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))

	$yaml = [System.IO.File]::ReadAllText($YamlFile)
	$yamlObject = $yaml | ConvertFrom-Yaml -Ordered
	if($yamlObject.SharedFields)
	{
		$blob = $yamlObject.SharedFields | Where-Object Hint -eq 'Blob'
		if($blob -and $blob.Value)
		{
			$blob.Value = $base64;
			$size = $yamlObject.SharedFields | Where-Object Hint -eq 'Size'
			if($size -and $size.Value)
			{
				$size.Value = $content.Length
			}

			$content = $yamlObject | ConvertTo-Yaml
			$content = "---`r`n{0}" -f $content
			[System.IO.File]::WriteAllText($YamlFile, $content)
			return $true
		}
		else 
		{
			return $false
		}
	}
	else
	{
		Write-Error "Yaml does not have SharedFields"
		return $false
	}
	
}