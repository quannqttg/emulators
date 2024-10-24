# Define the path to the "anime" directory based on the current user's Desktop
$animeDir = "C:\Users\$env:USERNAME\Desktop\anime"

# Set the path to the batch file in the "anime" directory
$batchFile = "$animeDir\reset_network.bat"

# Create a new process start info object
$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.FileName = "cmd.exe"
$startInfo.Arguments = "/c $batchFile"
$startInfo.WindowStyle = 'Hidden'  # This hides the command window
$startInfo.CreateNoWindow = $true  # Ensures no window is created

# Start the process
$process = [System.Diagnostics.Process]::Start($startInfo)

# Optional: Wait for the process to exit (or you can let it run in the background)
$process.WaitForExit()
