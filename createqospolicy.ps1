# Script to create a QoS Policy that applies to all traffic with DSCP Value = 20 and Throttle Rate = 500 Kbps

# Define the policy name
$policyName = "LimitBandwidthAllApps"

# Check if the policy already exists, and if so, remove it before creating a new one
if (Get-NetQosPolicy -PolicyStore ActiveStore -Name $policyName -ErrorAction SilentlyContinue) {
    Remove-NetQosPolicy -Name $policyName -PolicyStore ActiveStore -Confirm:$false
    Write-Output "Old policy removed: $policyName"
}

# Create a new QoS Policy
New-NetQosPolicy -Name $policyName `
                 -PolicyStore ActiveStore `
                 -ThrottleRateActionBitsPerSecond 500000 `
                 -DSCPAction 20 `
                 -NetworkProfile All

Write-Output "New QoS Policy created: $policyName with DSCP Value = 20 and Throttle Rate = 500 Kbps"

# Define the path to the "anime" directory based on the current user's Desktop
$animeDir = "C:\Users\$env:USERNAME\Desktop\anime"

# Set the path to the batch file in the "anime" directory
$batchFile = "$animeDir\createqospolicy.bat"
Write-Output "Batch file path set to: $batchFile"
