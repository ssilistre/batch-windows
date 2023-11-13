@echo off
setlocal enabledelayedexpansion

REM Disk alanını kontrol et
for /f "tokens=2 delims==" %%F in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value') do set freeSpace=%%F
for /f "tokens=2 delims==" %%F in ('wmic logicaldisk where "DeviceID='C:'" get Size /value') do set totalSpace=%%F

REM Disk kullanım yüzdesini hesapla
set /a usedSpace=!totalSpace! - !freeSpace!
set /a percentUsed=!usedSpace! * 100 / !totalSpace!

REM Eğer kullanım %80 veya daha fazlaysa, temizlik yap
if !percentUsed! geq 80 (
    echo Disk kullanımı %80'in üzerinde. Temizlik yapılıyor...

    REM Temp dosyalarını sil
    del /s /q %temp%\*

    REM 'Program Files' altındaki 'scoped_dir' ile başlayan dosyaları sil
    for /d %%D in ("C:\Program Files\scoped_dir*") do (
        rmdir /s /q "%%D"
    )

    echo Temizlik tamamlandı.
) else (
    echo Disk kullanımı %80'in altında. Temizlik gerekmiyor.
)

endlocal
