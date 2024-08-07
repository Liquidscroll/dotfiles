function Is-Admin
{
    $winID = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    $windPrinc = New-Object System.Security.Principal.WindowsPrincipal($winID)

    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

    return $windPrinc.IsInRole($adminRole)
}
function Get-GitBranch
{
    if(git rev-parse --is-inside-work-tree 2>$null)
    {
        return git rev-parse --abbrev-ref HEAD
    }
    else
    {
        return ""
    }
}


function prompt
{
    $promptLineCount = 0
    $coloursFilePath = "$HOME\dotfiles\shell_colours.json"

    if(Test-Path $coloursFilePath)
    {
        $colorSettings = Get-Content $coloursFilePath | ConvertFrom-Json
        
        foreach ($key in $colorSettings.PSObject.Properties)
        {
            $key.Value = $key.Value.Replace("\e", "`e")
        }
    }
    else
    {
        #define colours if json file doesn't exist
        $colorSettings = @{
            "bg_color" = "`e[48;5;234m"
            "fg_color"= "`e[38;5;231m"
            "black"= "`e[38;5;16m"
            "red"= "`e[38;5;197m"
            "green"= "`e[38;5;154m"
            "yellow"= "`e[38;5;220m"
            "blue"= "`e[38;5;81m"
            "magenta"= "`e[38;5;141m"
            "cyan"= "`e[38;5;115m"
            "white"= "`e[38;5;231m"
            "reset"= "`e[0m"
        }
    }

    $user = [Environment]::UserName
    $path = Get-Location
    $gitBranch = Get-GitBranch
    $gitSymbol = "`u{e725}"

    $promptString  = "$($colorSettings.white)@$user "
    $promptString += "$($colorSettings.blue)$path`n"
    $promptLineCount += 1
    if($gitBranch) 
    { 
        $promptString += "$($colorSettings.yellow)$gitSymbol $gitBranch`n" 
        $promptLineCount += 1
    } 

    $promptString += "$($colorSettings.green)"
    if(Is-Admin)
    {
        $promptString += "#"
    }
    else
    {
        $promptString += "$"
    }

    # Indicate to PS extra lines in the prompt (3 total) 
    Set-PSReadLineOption -ExtraPromptLineCount ($promptLineCount)

    # Turn off terminal sounds
    Set-PSReadLineOption -BellStyle None

    # Reset Command Colours back to Gray
    Set-PSReadLineOption -Colors @{ "Command" = [ConsoleColor]::Gray } 
    
    Write-Host -NoNewline $promptString
    return " "
}

