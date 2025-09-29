<#
CPU Stress Test
=====================================================================================
This script performs CPU-intensive calculations to test processor performance
under load and displays the current CPU clock speed.
#>

function Start-Countdown {
    param([int]$Seconds)
    
    Write-Host "`nStarting CPU stress test..." -ForegroundColor Green
    Write-Host "Duration: $Seconds seconds" -ForegroundColor Yellow
    Write-Host "Performing intensive calculations..." -ForegroundColor Cyan
    Write-Host "`n" + ("=" * 50) -ForegroundColor DarkGray
    
    for ($i = $Seconds; $i -gt 0; $i--) {
        # Display progress with color coding
        if ($i -gt 5) {
            $color = "Green"
        } elseif ($i -gt 2) {
            $color = "Yellow" 
        } else {
            $color = "Red"
        }
        
        Write-Host "Time remaining: " -NoNewline
        Write-Host $i -NoNewline -ForegroundColor $color
        Write-Host " seconds"
        
        # CPU-intensive calculation
        $result = 1..500000 | ForEach-Object { 
            [math]::Sqrt($_) + [math]::Pow($_, 1.5) - [math]::Log($_ + 1)
        }
        
        # Small delay to make countdown visible
        Start-Sleep -Milliseconds 50
    }
    
    Write-Host "`n" + ("=" * 50) -ForegroundColor DarkGray
    Write-Host "CPU stress test completed!" -ForegroundColor Green
}

function Get-CPUSpeed {
    try {
        $cpu = Get-WmiObject -Class Win32_Processor | Select-Object -First 1
        if ($cpu -and $cpu.CurrentClockSpeed -gt 0) {
            return $cpu.CurrentClockSpeed
        } else {
            return "N/A"
        }
    } catch {
        Write-Warning "Could not retrieve CPU speed: $($_.Exception.Message)"
        return "N/A"
    }
}

# Main execution
Clear-Host
Write-Host "CPU STRESS TEST UTILITY" -ForegroundColor Magenta
Write-Host "==========================" -ForegroundColor DarkGray

# Display initial CPU speed
$initialSpeed = Get-CPUSpeed
if ($initialSpeed -ne "N/A") {
    Write-Host "Initial CPU Speed: $initialSpeed MHz" -ForegroundColor Cyan
} else {
    Write-Host "Initial CPU Speed: Unable to determine" -ForegroundColor Yellow
}

Write-Host "`nThis test will:" -ForegroundColor White
Write-Host "  • Perform intensive mathematical calculations" -ForegroundColor Gray
Write-Host "  • Run for 10 seconds" -ForegroundColor Gray  
Write-Host "  • Show real-time countdown" -ForegroundColor Gray
Write-Host "  • Display final CPU speed" -ForegroundColor Gray

Write-Host "`nNote: This may cause temporary system slowdown!" -ForegroundColor Red
Write-Host "Close other intensive applications before continuing.`n" -ForegroundColor Yellow

# Confirmation prompt
$response = Read-Host "Press Enter to start the test (or 'Q' to quit)"
if ($response -eq 'Q' -or $response -eq 'q') {
    Write-Host "Test cancelled by user." -ForegroundColor Yellow
    exit
}

# Run the stress test
Start-Countdown -Seconds 10

# Display results
Write-Host "TEST RESULTS" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor DarkGray

$finalSpeed = Get-CPUSpeed
if ($finalSpeed -ne "N/A" -and $initialSpeed -ne "N/A") {
    Write-Host "Initial CPU Speed: $initialSpeed MHz" -ForegroundColor Gray
    Write-Host "Final CPU Speed:   $finalSpeed MHz" -ForegroundColor Cyan
    
    $difference = $finalSpeed - $initialSpeed
    if ($difference -gt 0) {
        Write-Host "Speed Change:      +$difference MHz" -ForegroundColor Green
    } elseif ($difference -lt 0) {
        Write-Host "Speed Change:      $difference MHz" -ForegroundColor Red  
    } else {
        Write-Host "Speed Change:      No change" -ForegroundColor Yellow
    }
} else {
    Write-Host "Final CPU Speed: $finalSpeed MHz" -ForegroundColor Cyan
}

Write-Host "`nTest completed at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

# Optional: System info
try {
    $cpuInfo = Get-WmiObject -Class Win32_Processor | Select-Object -First 1
    Write-Host "SYSTEM INFORMATION" -ForegroundColor Magenta
    Write-Host "===================" -ForegroundColor DarkGray
    Write-Host "Processor: $($cpuInfo.Name)" -ForegroundColor Gray
    Write-Host "Cores: $($cpuInfo.NumberOfCores)" -ForegroundColor Gray
    Write-Host "Threads: $($cpuInfo.NumberOfLogicalProcessors)" -ForegroundColor Gray
} catch {
    # Skip system info if unavailable
}

Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")