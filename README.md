# StayAwake
## Description
I got irritated by Windows putting my computer to sleep while certain programs were running (*cough*Spotify*cough*), so I decided to throw this together to fix that.
Probably duplicative, but a fun side project.

## Available Functions

### Disable-SleepWhile
Blocks sleep while the one or more processes are running. Can be run inline or as a job.
Running as a job, it will end automatically if none of the processes passed to ProcessName are running past the MaxTries poll limit; polls are every PollSec seconds.

### Get-Sleep
Gets the current ThreadExecutionState to check if ES_DISPLAY_REQUIRED or ES_SYSTEM_REQUIRED is set; says if sleep is enabled or disabled as a result.

Optionally prints the flags as a printed table and/or returns them as a hashtable.

### Disable-Sleep
Sets ES_CONTINUOUS, ES_DISPLAY_REQUIRED, and ES_SYSTEM_REQUIRED bits on the ThreadExecutionState to prevent sleep.

### Enable-Sleep
Resets ThreadExecutionState to stop blocking sleep.

## Roadmap

[x] Basic functionality: Set ThreadExecutionState in a PowerShell process to prevent sleep
[ ] Test that it does what I want and not just what I told it to do...
[ ] Update Get-Sleep to be able to check SystemExecutionState instead of just ThreadExecutionState