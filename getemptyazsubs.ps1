$Subscriptions = Get-AzSubscription

foreach ($sub in $Subscriptions) {
    Select-AzSubscription -Subscription $sub.Id
    $resourceGroups = Get-AzResourceGroup
    foreach ($resourceGroup in $ResourceGroups) {
        $ResourceGroupName = $resourceGroup.ResourceGroupName
        $count = (Get-AzResource | Where-Object{ $_.ResourceGroupName -match $ResourceGroupName }).Count
        if ($count -eq 0) {
            Write-Host "$ResourceGroupName has no resources. Writing to CSV file."
            Get-AzResourceGroup -ResourceGroupName $ResourceGroupName | Select-Object ResourceGroupName, Location | Export-Csv -Path "$($sub.name)-EmtpyRG.csv" -append
        }
    }
}
