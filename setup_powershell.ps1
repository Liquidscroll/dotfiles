$vimrcPath = "$PSScriptRoot/.vimrc"
$psPromptPath = "$PSScriptRoot/profile.ps1"

$targetVimrcPath = "$HOME/_vimrc"
$targetPsPromptPath = "$HOME/Documents/PowerShell/Profile.ps1"

if (-Not (Test-Path $targetVimrcPath -PathType Leaf))
{
    New-Item -ItemType SymbolicLink -Path $targetVimrcPath -Target $vimrcPath
    Write-Output "Symbolic link created from $vimrcPath to $targetVimrcPath"
}
else
{
    Write-Output "Symbolic link already exists at $targetVimrcPath"
}

if (-Not (Test-Path $targetPsPromptPath -PathType Leaf))
{
    New-Item -ItemType SymbolicLink -Path $targetPsPromptPath -Target $psPromptPath
    Write-Output "Symbolic link created from $psPromptPath to $targetPsPromptPath"
}
else
{
    Write-Output "Symbolic link already exists at $targetPsPromptPath"
}
