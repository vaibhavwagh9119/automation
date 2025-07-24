param(
    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName
)

# Connect to Azure using the managed identity
Write-Output "Connecting to Azure..."
Connect-AzAccount -Identity

# List all VMs in the specified resource group
Write-Output "Retrieving VMs in resource group: $ResourceGroupName"
$vmList = Get-AzVM -ResourceGroupName $ResourceGroupName

if ($vmList.Count -eq 0) {
    Write-Output "No VMs found in resource group: $ResourceGroupName"
} else {
    foreach ($vm in $vmList) {
        Write-Output "VM Name: $($vm.Name), Status: $($vm.ProvisioningState)"
    }
}
