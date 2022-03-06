
Try {
    $THEME = Read-Host -Prompt "Enter the theme name you want to install (default is my-clean-detailed)"
    if ($THEME -eq "") {
        $THEME = "my-clean-detailed"
    }
    $THEME = ".$THEME"

    Install-Module oh-my-posh -Scope CurrentUser 

    Import-Module oh-my-posh

    Install-Module -Name Terminal-Icons -Repository PSGallery 
    Write-Host "Installed Terminal-Icons..."
    Write-Host "Icons needs a font to be displayed. Please install the font from here: https://www.nerdfonts.com/font-downloads"

    $HOMEDIR = (Get-Item -Path "~").FullName
    $FILEPATH = "$HOMEDIR\.posh-themes\$THEME.omp.json"
    oh-my-posh --init --shell pwsh --config $FILEPATH | Invoke-Expression

    $POWERSHELLDIR = [Environment]::GetEnvironmentVariable('PSModulePath') -split "Modules;"
    $POWERSHELLDIR = $POWERSHELLDIR[0]
    Try {
        New-Item -Path $POWERSHELLDIR -ItemType File -Name "Microsoft.PowerShell_profile.ps1"
    } catch {
        Write-Host "Profile file already exists..."
    }
    $CONTENT = "Set-PoshPrompt -Theme $FILEPATH `n Import-Module -Name Terminal-Icons"
    $CONTENT | Out-File -FilePath $POWERSHELLDIR\Microsoft.PowerShell_profile.ps1 -Append
    Write-Host "Default powershell profile has been created to $POWERSHELLDIR..."

    Copy-Item -Path ".posh-themes" -Destination $HOMEDIR -Recurse -Force
    Write-Host "Directory .posh-themes copied to $HOMEDIR..."

    oh-my-posh --init --shell pwsh --config $FILEPATH | Invoke-Expression	

    Write-Host "Installation complete. Please restart your terminal."
    Write-Host 'If you have any problems, please try the following command: . $PROFILE'
    Write-Host "If this doesn't work, you can manually run the following command:"
    Write-Host "Install-Module oh-my-posh -Scope CurrentUser"
    Write-Host "Import-Module oh-my-posh"
    Write-Host "Install-Module -Name Terminal-Icons -Repository PSGallery "
    Write-Host "oh-my-posh --init --shell pwsh --config ~/.$THEME.omp.json | Invoke-Expression"
    Write-Host "$PROFILE"
    Write-Host "Create a Microsoft.PowerShell_profile.ps1 file in your $POWERSHELLDIR (powershell installation) directory"
    Write-Host "Add the following line to the file:"
    Write-Host "$CONTENT"
    Write-Host "And try the following command:"
    Write-Host ". $PROFILE"
    Write-Host "If this still not works, you can try to restart your terminal."

}  Catch {
    Write-Host "Something went wrong. Please try again..."
}