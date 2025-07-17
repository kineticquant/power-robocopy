# ---CONFIGURATION---
$sourceDrive = "X:\"
$destinationBase = "Y:\Target\"
$foldersToCopy = @(
    "Folder1",
    "Folder2"
)
# ---END CONFIGURATION---

$dateStamp = Get-Date -Format "yyyy-MM-dd"
$backupFolderName = "Share Backup $dateStamp"
$finalDestination = Join-Path -Path $destinationBase -ChildPath $backupFolderName
$logFile = Join-Path -Path $finalDestination -ChildPath "BackupLog-$dateStamp.txt"

# initialize transcript to log
Start-Transcript -Path (Join-Path -Path $destinationBase -ChildPath "PowerShellLog-$dateStamp.txt") -Append

# make dest
if (-not (Test-Path -Path $finalDestination)) {
    Write-Host "Creating destination folder: $finalDestination"
    New-Item -Path $finalDestination -ItemType Directory -ErrorAction Stop | Out-Null
}

# robocopy params
$robocopyOptions = @(
    "/E",           # copies subdir incl empties 
    "/COPY:DAT",    # copies all data/attr/timestamps - change this for more expansive copying
    "/MT:16",       # 16 threds - add or remove as needed
    "/R:2",         # 2 retries when failed
    "/W:5",         # 5 sec wait b/w retries
    "/V",           # verbose output for logging
    "/NP",          # if no progress then doesnt show % copied for each file and cleanses logger
    "/TEE",         # output for console / logger
    "/LOG+:$logFile" # appends to logger
)

Write-Host "Starting backup process... Log file will be saved to: $logFile" -ForegroundColor Cyan
foreach ($folder in $foldersToCopy) {
    $sourceFolder = Join-Path -Path $sourceDrive -ChildPath $folder
    $destinationFolder = Join-Path -Path $finalDestination -ChildPath $folder
    
    if (Test-Path -Path $sourceFolder) {
        Write-Host "--------------------------------"
        Write-Host "Copying '$sourceFolder'..."
        
        robocopy.exe $sourceFolder $destinationFolder $robocopyOptions
        
        if ($LASTEXITCODE -le 7) {
            Write-Host "Successfully copied '$folder'." -ForegroundColor Green
        } else {
            Write-Host "ERROR: Robocopy finished with exit code $LASTEXITCODE for folder '$folder'. Check log for details." -ForegroundColor Red
        }
    } else {
        Write-Host "WARNING: Source folder '$sourceFolder' not found. Skipping." -ForegroundColor Yellow
    }
}

Write-Host "--------------------------------"
Write-Host "Backup script finished! See logs for details." -ForegroundColor Cyan

Stop-Transcript
