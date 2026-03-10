param(
    [string[]]$Servers = @("localhost")
)

$results = @()

foreach ($server in $Servers) {

    Write-Host "Checking $server ..." -ForegroundColor Cyan

    $cpu = Get-CimInstance Win32_Processor -ComputerName $server |
    Measure-Object -Property LoadPercentage -Average |
    Select -ExpandProperty Average

    $memory = Get-CimInstance Win32_OperatingSystem -ComputerName $server
    $memUsed = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)

    $disk = Get-CimInstance Win32_LogicalDisk -ComputerName $server -Filter "DriveType=3" |
    Select DeviceID,
    @{Name = "FreeGB"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2).ToString("F2", [System.Globalization.CultureInfo]::InvariantCulture) } }

    $errors = Get-WinEvent -ComputerName $server -FilterHashtable @{
        LogName   = 'System'
        Level     = 2
        StartTime = (Get-Date).AddHours(-24)
    } | Measure-Object | Select -ExpandProperty Count

    $results += [PSCustomObject]@{
        Server        = $server
        CPU           = "$cpu %"
        Memory        = "$memUsed %"
        DiskFree      = ($disk.FreeGB -join ";")
        ErrorsLast24h = $errors
    }
}

$results | Format-Table
$results | Export-Csv server-health.csv -NoTypeInformation