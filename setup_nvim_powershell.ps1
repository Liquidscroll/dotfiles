# Install Neovim
choco install -y neovim
refreshenv

# Add Nvim to path
$pathToAdd = 'C:\tools\nvim\nvim-win64\bin'
$currentPath = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User)
if ($currentPath -notlike "*$pathToAdd*") 
{
    $newPath = "$currentPath;$pathToAdd"
    [Environment]::SetEnvironmentVariable('PATH', $newPath, [EnvironmentVariableTarget]::User)
    Write-Host "Neovim added to PATH added successfully."
} 
else 
{
    Write-Host "The PATH already contains $pathToAdd."
} 

$nvimInitPath = "$PSScriptRoot/init.vim"
$psPromptPath = "$PSScriptRoot/profile.ps1"

#For NVIM, don't need vimrc or clangcomplete

$targetNvimInitPath = "$HOME/.config/nvim/init.vim"
$targetPsPromptPath = "$HOME/Documents/PowerShell/Profile.ps1"

$nvimConfigDirectory = "$HOME/.config/nvim"
$windowsNvimConfigDirectory = "$HOME/AppData/Local/nvim/init.vim"

# Check if ~/.config/vim exists
if(-Not (Test-Path $nvimConfigDirectory))
{
    # Make config directory
    New-Item -Path $nvimConfigDirectory -ItemType Directory -Force
}

# Check if link to nvim init.vim exists
if(-Not(Test-Path $targetNvimInitPath -PathType Leaf))
{
    New-Item -ItemType SymbolicLink -Path $targetNvimInitPath -Target $nvimInitPath
    Write-Output "Symbolic link created from $nvimInitPath to $targetNvimInitPath"
}
else
{
    Write-Output "Symbolic link already exists at $targetNvimInitPath"
}

# Check if windows Nvim Config Directory exists
$dirPath = [System.IO.Path]::GetDirectoryName($windowsNvimConfigDirectory)
if (-Not (Test-Path $dirPath))
{
    New-Item -Path $dirPath -ItemType Directory
}

# Define content to add to win Nvim config
# This is the same location linux nvim config will go.
$content = 'source ~/.config/nvim/init.vim'
if (Test-Path $winNvimConfigLoc) 
{
    $existingContent = Get-Content -Path $winNvimConfigLoc
    if ($existingContent -notcontains $content) 
    {
        Add-Content -Path $winNvimConfigLoc -Value $content
    }                           
} 
else
{
    Set-Content -Path $winNvimConfigLoc -Value $content
}

# Check if symbolic link exists for profile.ps1
if (-Not (Test-Path $targetPsPromptPath -PathType Leaf))
{
    New-Item -ItemType SymbolicLink -Path $targetPsPromptPath -Target $psPromptPath
    Write-Output "Symbolic link created from $psPromptPath to $targetPsPromptPath"
}
else
{
    Write-Output "Symbolic link already exists at $targetPsPromptPath"
}

