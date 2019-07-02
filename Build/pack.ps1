# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/set-env.ps1"
$all_ok = $True

function Pack-One() {
    Param($project)

    dotnet pack (Join-Path $PSScriptRoot $project) `
        --no-build `
        -c $Env:BUILD_CONFIGURATION `
        -v $Env:BUILD_VERBOSITY `
        -o $Env:NUGET_OUTDIR `
        /property:PackageVersion=$Env:NUGET_VERSION 

    $script:all_ok = ($LastExitCode -eq 0) -and $script:all_ok
}

Write-Host "##[info]Packing Research library..."
Pack-One '../Research/src/Research.csproj'


if (-not $all_ok) {
    throw "At least one test failed execution. Check the logs."
}