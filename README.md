# CPU Stress Test

A PowerShell script that puts the CPU under load for 10 seconds with math-heavy loops and shows the CPU clock speed before and after.

## What it does

1. Reads the current CPU clock speed from WMI.
2. Explains what the test will do and asks you to press Enter to start (or Q to quit).
3. Runs the calculations with a colour-coded countdown (green, then yellow, then red).
4. Reads the clock speed again and shows the results.

## Run it

```powershell
.\cpu_stress_test.ps1
```

If PowerShell refuses to run scripts:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Needs Windows PowerShell 5.1 or newer. Close other heavy programs first: the computer can slow down while the test runs.
