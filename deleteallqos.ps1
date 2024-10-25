# Script to delete all QoS Policies

# Get all QoS Policies in the ActiveStore
$qosPolicies = Get-NetQosPolicy -PolicyStore ActiveStore -ErrorAction SilentlyContinue

if ($qosPolicies) {
    foreach ($policy in $qosPolicies) {
        # Remove the QoS Policy
        Remove-NetQosPolicy -Name $policy.Name -PolicyStore ActiveStore -Confirm:$false
        Write-Output "Removed QoS Policy: $($policy.Name)"
    }
    Write-Output "All QoS Policies have been removed."
} else {
    Write-Output "No QoS Policies found in ActiveStore."
}
