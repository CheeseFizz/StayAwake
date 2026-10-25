Add-Type @"
using System;
using System.Runtime.InteropServices;
public class ExecState {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
"@


$ES_CONTINUOUS = [UInt32]"0x80000000"
$ES_SYSTEM_REQUIRED = [UInt32]"0x00000001"
$ES_DISPLAY_REQUIRED = [UInt32]"0x00000002"


function Disable-Sleep {
    [ExecState]::SetThreadExecutionState($ES_CONTINUOUS -bor $ES_SYSTEM_REQUIRED -bor $ES_DISPLAY_REQUIRED) | Out-Null
}

function Enable-Sleep {
    [ExecState]::SetThreadExecutionState($ES_CONTINUOUS) | Out-Null
}

function Get-Sleep {
    param(
        [switch]$ShowFlags,
        [switch]$ReturnFlags
    )
    $ExecutionState = [ExecState]::SetThreadExecutionState(0)

    $flags = @{
        es_continuous = $false;
        es_system_required = $false;
        es_display_required = $false;
    }

    if ($ExecutionState -band $ES_CONTINUOUS -gt 0x00) {
        $flags["es_continuous"] = $true
    }
    if ($ExecutionState -band $ES_SYSTEM_REQUIRED -gt 0x00) {
        $flags["es_system_required"] = $true
    }
    if ($ExecutionState -band $ES_DISPLAY_REQUIRED -gt 0x00) {
        $flags["es_display_required"] = $true
    }

    $check = $false
    foreach ($flagname in $flags.GetEnumerator().Name) {
        if ($check) {break}
        if ($flagname -eq "es_continuous") {continue}
        $check = $flags.$flagname
    }

    # Output stuff
    if ($check) {
        Write-Host "`n- Sleep is disabled -`n" -ForegroundColor Red
    }
    else {
        Write-Host "`n- Sleep is enabled -`n" -ForegroundColor Green
    }
    if ($ShowFlags) {
        # Write-Host "Flag | State"
        # foreach ($flagname in $flags.GetEnumerator().Name) {
        #     Write-Host "$flagname | $($flags.$flagname)"
        # }
        $flags | Format-Table
    }
    if ($ReturnFlags) {
        return $flags
    }
}