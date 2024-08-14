$vimrcPath = "$PSScriptRoot/.vimrc"
$psPromptPath = "$PSScriptRoot/profile.ps1"
$codeiumPath = "$PSScriptRoot/plugins/codeium.vim"
$clangCompletePath = "$PSScriptRoot/plugins/clang_complete"

$targetVimrcPath = "$HOME/_vimrc"
$targetPsPromptPath = "$HOME/Documents/PowerShell/Profile.ps1"
$targetCodeiumPath = "$HOME/vimfiles/pack/Exafunction/start/codeium.vim"
$targetClangCompletePath = "$HOME/vimfiles/pack/completion/start/clang_complete"

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

if (-Not (Test-Path $targetCodeiumPath -PathType Any))
{
    if(-Not (Test-Path $targetCodeiumPath -PathType Container))
    {
        New-Item -ItemType Directory -Path (Split-Path $targetCodeiumPath) 
    }
    New-Item -ItemType SymbolicLink -Path $targetCodeiumPath -Target $codeiumPath 
    Write-Output "Symbolic link created from $codeiumPath to $targetCodeiumPath"
}
else
{
    Write-Output "Symbolic Link already exists at $targetCodeiumPath"
}

if (-Not (Test-Path $targetClangCompletePath -PathType Any))
{
    if(-Not (Test-Path $targetClangCompletePath -PathType Container))
    {
        New-Item -ItemType Directory -Path (Split-Path $targetClangCompletePath) 
    }
    New-Item -ItemType SymbolicLink -Path $targetClangCompletePath -Target $clangCompletePath 
    Write-Output "Symbolic link created from $clangCompletePath to $targetClangCompletePath"
}
else
{
    Write-Output "Symbolic Link already exists at $targetClangCompletePath"
}
