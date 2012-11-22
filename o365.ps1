#——– El siguiente script automatiza una conexión contra O365 ———–
	
	#——– Previamente es necesario haber creado el fichero con el password cifrado, ———–
		# read-host -assecurestring | convertfrom-securestring | out-file C:\securestring.txt 
		
	#——– Se define el usuario con el que se realizará la conexión ———–
	$user = “tasks@tokiota.com”
 
    #——– Se importa el module de Microsoft Online PowerShell Module. Es necesario haberlo instalado antes ——–
	
	Import-Module MSOnline
	
	#——– Se realiza  la conexión contra O365 ———–
    $pass = cat C:\securestring_tokiota.txt | convertto-securestring
    $mycreds = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass

    Connect-MsolService -Credential $mycreds

    #———— Se establece una sesión remota contra Exchange Online ———————

    $msoExchangeURL = “https://ps.outlook.com/powershell/”

    $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $msoExchangeURL -Credential $mycreds -Authentication Basic -AllowRedirection

    Import-PSSession $session

    #———— Ejecución del script ———————

	cd "C:\temp\Helper Scripts o365"
	.\GetMsolUserReport.ps1 -OutputFile Users.csv
	Remove-PsSession $session

    # En este punto, se podrá utiliza:

    # 1] cmdlets de MSOL Powershell como por ejemplo Get-MsolUser

    # 2] cmdlets de Exchange Online como por ejemplo Get-Mailbox

    # Al finalizar, se recomienda eliminar la sesión creada.
		# Remove-PsSession $session