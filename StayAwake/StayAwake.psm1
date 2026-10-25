. "$PSScriptRoot\Resources\StayAwakeHelpers.ps1"
function Disable-SleepWhile {
    <#
    .SYNOPSIS
    Disable sleep while the specified processes are running.
    
    .DESCRIPTION
    Disable sleep while the specified processes are running.
    
    .PARAMETER ProcessName
    One or more process names (i.e. "spotify.exe"); sleep will be disabled while these are running.
    
    .PARAMETER MaxTries
    Use with AsJob. If ProcessName is not found after being polled this many times, the job will end.
    
    .PARAMETER PollSec
    Seconds to wait between process polls. Default 60.

    .PARAMETER AsJob
    Run as job. Returns a job object.
    
    .EXAMPLE
    # Runs a job that ends after Spotify is closed for 10 minutes
    $job = Disable-SleepWhile -ProcessName "spotify" -MaxTries 10 -AsJob

    .EXAMPLE
    # Continues to run until sigterm (ctrl-c)
    Disable-SleepWhile -ProcessName "spotify"
    
    .NOTES
    General notes
    #>
    param(
        [string[]]$ProcessName = @(),
        [int]$MaxTries = 2,
        [int]$PollSec = 60,
        [switch]$AsJob
    )

    if ($ProcessName -eq "") {
        throw [System.ArgumentException] "must provide a process name"
    }

    $sb = {
        param(
            [string[]]$pn,
            [int]$mt,
            [int]$ps,
            $Root
        )
        . "$Root\Resources\StayAwakeHelpers.ps1"

        $tries = 0
        while ($true) {
            $processes = Get-Process -Name $pn
            if ($processes.length -gt 0) {
                Disable-Sleep
                $tries = 0
            }
            elseif ($tries -lt $mt) {
                $tries += 1
            }
            else {
                Enable-Sleep
            }
            Start-Sleep -Seconds $ps
        }
    }

    if ($AsJob) {
        $job = Start-Job -ScriptBlock $sb -ArgumentList @($ProcessName, $MaxTries, $PollSec, $PSScriptRoot) -Name "Disable-SleepWhile"
        return $job
    }

    & $sb -pn $ProcessName -mt $MaxTries -ps $PollSec -Root $PSScriptRoot
}

Export-ModuleMember -Function @(
    "Disable-Sleep",
    "Enable-Sleep",
    "Get-Sleep",
    "Disable-SleepWhile"
)