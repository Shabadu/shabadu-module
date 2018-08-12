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

	$found = $false;
	$lines = [System.IO.File]::ReadAllLines($YamlFile)
	for($i=0;$i -lt $lines.Length;$i++)
	{
		$l = $lines[$i];
		if($l -match "\sHint: Blob")
		{
			if(($i + 2) -lt $lines.Length)
			{
				$v = $lines[$i + 2]
				if($v -match "  Value:")
				{
					$found = $true;
					$lines[$i + 2] = "  Value: {0}" -f $base64
				}
			}
		}
		elseif($l -match "\sHint: Size")
		{
			if(($i + 1) -lt $lines.Length)
			{
				$v = $lines[$i + 1]
				if($v -match "  Value:")
				{
					$lines[$i + 1] = "  Value: {0}" -f $base64.Length
				}
			}
		}
	}

	[System.IO.File]::WriteAllLines($YamlFile, $lines)

	return $found
}