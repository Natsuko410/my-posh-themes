
Try {
    $THEME = Read-Host -Prompt "Enter the theme name you want to install (default is my-clean-detailed): "
    if ($THEME -eq "") {
        $THEME = "my-clean-detailed"
    }

    Install-Module oh-my-posh -Scope CurrentUser 

    Import-Module oh-my-posh

    Install-Module -Name Terminal-Icons -Repository PSGallery 

    $FILEPATH = ~/$THEME.omp.json
    oh-my-posh --init --shell pwsh --config $FILEPATH | Invoke-Expression

    $POWERSHELLDIR = (Get-Item -Path $PROFILE).FullName
    New-Item -Path $POWERSHELLDIR -ItemType File -Name "Microsoft.PowerShell_profile.ps1"
    $CONTENT = "Set-PoshPrompt -Theme clean-detailed\nImport-Module -Name Terminal-Icons" 
    $CONTENT | Out-File -FilePath $POWERSHELLDIR\Microsoft.PowerShell_profile.ps1 -Append
    Write-Host "Default powershell profile has been created to $POWERSHELLDIR..."

    $HOMEDIR = (Get-Item -Path "~").FullName
    Copy-Item -Path ".posh-themes" -Destination $HOMEDIR -Recurse -Force
    Write-Host "Directory .posh-themes copied to $HOMEDIR..."

    . $PROFILE

    Write-Host "Installation complete. Please restart your terminal."

}  Catch {
    Write-Host "Something went wrong. Please try again..."
}

# Run all the commands below:
# Install-Module oh-my-posh -Scope CurrentUser
# Import-Module oh-my-posh
# Install-Module -Name Terminal-Icons -Repository PSGallery 
# oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression
# $PROFILE
# Set-PoshPrompt -Theme jandedobbeleer
# Import-Module -Name Terminal-Icons
# . $PROFILE