# power-robocopy
Flexible/robust PowerShell script that leverages Robocopy to back up specified folders from a source to a destination. Designed for easy configuration and provides detailed logging for tracking backup operations.

## Overview

The primary goal of this script is to automate the process of backing up important folders. It creates a unique, date-stamped folder for each backup run, ensuring that previous backups are not overwritten. This provides a simple and effective version history of your files.

It uses **Robocopy**, a command-line utility built into Windows, which is highly regarded for its reliability, performance, and rich feature set for file replication. This is significantly better to utilize than the built-in Windows copy utility for many reasons and is far more performant.

## Features

-   **Easy Configuration**: A simple, centralized configuration block at the top of the script allows you to specify source, destination, and folders to back up without digging into the code.
-   **Automated Dated Folders**: Automatically creates a new backup folder with the current date (e.g., `Share Backup 2025-06-27`), keeping your backups organized and preventing data loss.
-   **Comprehensive Logging**: Generates two types of logs for each run:
    1.  A detailed **Robocopy log** (`BackupLog-*.txt`) with a file-by-file summary of the copy operation.
    2.  A high-level **PowerShell transcript** (`PowerShellLog-*.txt`) that captures all console output from the script itself.
-   **Robust Copying**: Utilizes Robocopy for efficient, multi-threaded copying that can handle network interruptions and retry failed files.
-   **Intelligent Sync**: Copies only new or changed files by default, making subsequent backups much faster.
-   **Error Reporting**: Checks the Robocopy exit code after each folder is copied and reports success or failure directly to the console with color-coded messages.
-   **User-Friendly Feedback**: Provides clear status messages in the console during execution.

## How to Use

1.  **Download:** Save the script file (e.g., `backup.ps1`) to your machine.

2.  **Configure:** Open the script in a text editor (like VS Code, Notepad++, Sublime, or Powershell ISE) and modify the variables in the `---CONFIGURATION---` section to match your needs.

3.  **Run the Script:**
    *   Open a PowerShell terminal.
    *   Navigate to the directory where you saved the script, if desired, or run directly from ISE. Note - Administrative permissions are NOT necessary as this utility is NOT copying audit trails. If you wish to incorporate audit trail metadata, then you will need to configure that in the Robocopy Options section of the code by replacing "/COPY:DAT" with the applicable parameter, and run the script as admin.
    *   Execute the script:
        ```powershell
        .\backup.ps1
        ```
    *   **Note:** If you encounter an execution policy error, you may need to run the script with a bypassed execution policy for the current session. This is generally safe for scripts you trust.
        ```powershell
        PowerShell.exe -ExecutionPolicy Bypass -File .\backup.ps1
        ```

## Configuration Details

All user settings are located in the `---CONFIGURATION---` block at the top of the script.

```powershell
# ---CONFIGURATION---
$sourceDrive = "X:\"
$destinationBase = "Y:\target_dir_example\"
$foldersToCopy = @(
    "Folder1",
    "Folder2",
    "Another Folder"
   # Continue adding anything you wish to copy. It will recursively copy content from within these folders and log each item copied.
)
# ---END CONFIGURATION---
