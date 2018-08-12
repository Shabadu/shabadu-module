. "$PSScriptRoot\Add-DCHosts.ps1"
. "$PSScriptRoot\Install-DCCert.ps1"
. "$PSScriptRoot\Compare-MediaItem.ps1"
. "$PSScriptRoot\Update-MediaItem.ps1"

New-Alias -Name adch -Value Add-DCHosts
New-Alias -Name idcc -Value Install-DCCert