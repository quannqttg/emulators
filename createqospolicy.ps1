# Define the QoS Policy name
$policyName = "MyQoSPolicy"

# Function to get the user's desired throttle rate in Mbps
function Get-UserThrottleRate {
    $input = Read-Host "Enter the desired throttle rate in Mbps"
    
    # Validate the input to ensure it's a positive number
    if ($input -as [int] -and [int]$input -gt 0) {
        return [int]$input * 1MB  # Convert Mbps to bits per second
    } else {
        Write-Output "Invalid input. Please enter a positive number."
        exit
    }
}

# Get the user's desired throttle rate
$throttleRate = Get-UserThrottleRate

# Check if the policy already exists, and if so, remove it before creating a new one
if (Get-NetQosPolicy -PolicyStore ActiveStore -Name $policyName -ErrorAction SilentlyContinue) {
    Remove-NetQosPolicy -Name $policyName -PolicyStore ActiveStore -Confirm:$false
    Write-Output "Old policy removed: $policyName"
}

# Create a new QoS Policy with the specified throttle rate
New-NetQosPolicy -Name $policyName `
                 -PolicyStore ActiveStore `
                 -ThrottleRateActionBitsPerSecond $throttleRate ` 
                 -DSCPAction 40 `
                 -NetworkProfile All

# Output the details of the new QoS Policy created
Write-Output "New QoS Policy created: $policyName"
Write-Output "   DSCP Value: 40"
Write-Output "   Throttle Rate: $($throttleRate / 1MB) Mbps"  # Display throttle rate in Mbps
Write-Output "   Policy Store: ActiveStore"
