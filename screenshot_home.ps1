$server = Start-Process -FilePath "node" -ArgumentList "C:\Users\farhan\AppData\Local\Temp\opencode\serve.js","--folder=D:\TUGAS KULIAH\semester 5\mobel\_3dmarket\build\web","--port=8765" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 2

$harness = @'
<!doctype html><html><head><meta charset="utf-8"><style>html,body{margin:0;background:#888;display:flex;justify-content:center}iframe{border:0;width:390px;height:1600px;background:#fff}</style></head><body><iframe src="http://localhost:8765/index.html"></iframe></body></html>
'@
[System.IO.File]::WriteAllText("D:\TUGAS KULIAH\semester 5\mobel\_3dmarket\build\web\harness.html", $harness, [System.Text.UTF8Encoding]::new($false))

$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
& $chrome --headless=new --disable-gpu --hide-scrollbars --window-size=900,1660 --virtual-time-budget=20000 --screenshot="C:\Users\farhan\AppData\Local\Temp\opencode\home_kurator.png" "http://localhost:8765/harness.html" 2>&1 | Out-Null
Stop-Process -Id $server.Id -Force
Write-Output "done"
