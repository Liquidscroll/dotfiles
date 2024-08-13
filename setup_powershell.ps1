$vimrcPath = "$PSScriptRoot/.vimrc"
$psPromptPath = "$PSScriptRoot/profile.ps1"
$clangCompletePath = "$PSScriptRoot/plugins/clang_complete"

$targetVimrcPath = "$HOME/_vimrc"
$targetPsPromptPath = "$HOME/Documents/PowerShell/Profile.ps1"
$targetClangCompletePath = "$HOME/.vim/pack/completion/start/clang_complete"

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

$clangVersion = clang --version
if($clangVersion)
{
    $libClangPath = gci -Recurse -Filter "libclang.dll" "C:\Program Files\LLVM" | Select-Object -First 1 -ExpandProperty FullName
    if($libClangPath)
    {
        $Env:LIB_CLANG_PATH = $libClangPath
    }
    else
    {
        Write-Output "libclang.dll not found."
    }
}
else
{
    Write-Output "Clang is not installed."
}


if ($clangVersion -and (-Not (Test-Path $targetClangCompletePath -PathType Any)))
{
    if(-Not (Test-Path $targetClangCompletePath -PathType Container))
    {
        New-Item -ItemType Directory -Path (Split-Path $targetClangCompletePath)
    }
    New-Item -ItemType SymbolicLink -Path $targetClangCompletePath -Target $clangCompletePath
    Write-Output "Symbolic link created from $clangCompletePath to $targetClangCompletePath"
}
elseif($clangVersion)
{
    Write-Output "Symbolic link already exists at $targetClangCompletePath"
}


