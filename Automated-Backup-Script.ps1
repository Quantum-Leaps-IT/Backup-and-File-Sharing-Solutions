# PowerShell Script for Automated Backups on Windows Server

# Function to perform Full Backup
function Perform-FullBackup {
    $destinationPath = "D:\Backups\Full" # Update with your backup destination path
    Write-Host "Starting Full Backup..."
    wbadmin start backup -backuptarget:$destinationPath -include:C: -allCritical -quiet
    Write-Host "Full Backup Completed."
}

# Function to perform Incremental Backup
function Perform-IncrementalBackup {
    $destinationPath = "D:\Backups\Incremental" # Update with your backup destination path
    Write-Host "Starting Incremental Backup..."
    wbadmin start backup -backuptarget:$destinationPath -include:C: -quiet
    Write-Host "Incremental Backup Completed."
}

# Schedule Full Backup every Monday at 4 AM
$fullBackupSchedule = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 4am

# Schedule Incremental Backup Daily at 11:45 PM
$incrementalBackupSchedule = New-ScheduledTaskTrigger -Daily -At 11:45pm

# Create Scheduled Tasks
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {Perform-FullBackup}"') -Trigger $fullBackupSchedule -TaskName "FullBackupTask" -Description "Weekly Full Backup Task"
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {Perform-IncrementalBackup}"') -Trigger $incrementalBackupSchedule -TaskName "IncrementalBackupTask" -Description "Daily Incremental Backup Task"

Write-Host "Backup tasks scheduled successfully."

# Resources (ChatGPT)[https://chat.openai.com/share/ee0ad8d7-53d1-4544-a626-3dde5c035434] 