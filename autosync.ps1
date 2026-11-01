<#
.SYNOPSIS
    Autosync ElectroMart: commit + pull --rebase + push otomatis setiap interval.

.DESCRIPTION
    Jalankan script ini dan biarkan terminal tetap terbuka. Setiap 60 detik
    (default) script akan:
      1. Mendeteksi perubahan file.
      2. Commit dengan pesan "autosync: <timestamp>" bila ada perubahan.
      3. Pull --rebase dari origin agar tidak bentrok.
      4. Push ke GitHub.

    Hentikan dengan Ctrl+C.

.PARAMETER IntervalSeconds
    Jeda antar siklus dalam detik. Default 60.

.PARAMETER Once
    Jalankan satu siklus saja lalu keluar.

.PARAMETER Branch
    Branch yang disinkronkan. Default "main".

.EXAMPLE
    .\autosync.ps1
    .\autosync.ps1 -IntervalSeconds 120
    .\autosync.ps1 -Once
#>
[CmdletBinding()]
param(
    [int]$IntervalSeconds = 60,
    [switch]$Once,
    [string]$Branch = "main"
)

$ErrorActionPreference = "Continue"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile  = Join-Path $RepoRoot "autosync.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Write-Host $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

function Invoke-Git {
    param([string[]]$GitArgs)
    $output = & git @GitArgs 2>&1
    return @{
        Code   = $LASTEXITCODE
        Output = ($output | Out-String).Trim()
    }
}

Set-Location $RepoRoot

# Validasi awal
$insideRepo = Invoke-Git @("rev-parse", "--is-inside-work-tree")
if ($insideRepo.Code -ne 0) {
    Write-Log "Folder $RepoRoot bukan git repository." "ERROR"
    exit 1
}

$remoteUrl = (Invoke-Git @("remote", "get-url", "origin")).Output
Write-Log "Autosync dimulai. Repo: $RepoRoot"
Write-Log "Remote: $remoteUrl | Branch: $Branch | Interval: ${IntervalSeconds}s"

$cycle = 0
try {
    while ($true) {
        $cycle++
        Write-Log "--- Siklus #$cycle ---"

        # 1. Apakah ada perubahan?
        $status = Invoke-Git @("status", "--porcelain")
        $hasChanges = -not [string]::IsNullOrWhiteSpace($status.Output)

        if ($hasChanges) {
            $null = Invoke-Git @("add", "-A")
            $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $commit = Invoke-Git @("commit", "-m", "autosync: $stamp")
            if ($commit.Code -eq 0) {
                Write-Log "Commit dibuat: autosync: $stamp"
            } else {
                Write-Log "Commit gagal: $($commit.Output)" "WARN"
            }
        } else {
            Write-Log "Tidak ada perubahan file."
        }

        # 2. Pull --rebase supaya tidak divergen
        $pull = Invoke-Git @("pull", "--rebase", "origin", $Branch)
        if ($pull.Code -ne 0) {
            Write-Log "Pull --rebase gagal. Membatalkan rebase dan mencoba lagi siklus berikutnya." "WARN"
            Write-Log $pull.Output "WARN"
            $null = Invoke-Git @("rebase", "--abort")
        }

        # 3. Push bila ada commit lokal yang belum terkirim
        $ahead = (Invoke-Git @("rev-list", "--count", "origin/$Branch..$Branch")).Output
        if ($ahead -match '^\d+$' -and [int]$ahead -gt 0) {
            $push = Invoke-Git @("push", "origin", $Branch)
            if ($push.Code -eq 0) {
                Write-Log "Push berhasil ($ahead commit terkirim ke origin/$Branch)."
            } else {
                Write-Log "Push gagal: $($push.Output)" "WARN"
            }
        } else {
            Write-Log "Sudah sinkron dengan origin/$Branch."
        }

        if ($Once) { break }

        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    Write-Log "Autosync dihentikan."
}
