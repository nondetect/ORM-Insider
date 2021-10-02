@echo off
set "scriptver=2.8.0"
chcp 866
for /f "tokens=1 delims=-" %%l in ('powershell -c "(get-uiculture).name"') do set "lang=%%l"
if /I "%lang%"=="ru"  ( goto :RU_LOCALE ) else ( goto :EN_LOCALE )

:CHECK_BUILD
for /f "tokens=4-5 delims=[]." %%a in ('ver') do set "build=%%a.%%b"
if %build:~0,5% LSS 17763 (
    echo =============================================================
    echo  %chbuild%
    echo =============================================================
    echo.
    pause
    goto :EOF )

reg query HKU\S-1-5-19 1>nul 2>nul
if %ERRORLEVEL% equ 0 goto :START_SCRIPT
echo =====================================================
echo %chadmin%
echo =====================================================
echo.
pause
goto :EOF

:START_SCRIPT
set "FlightSigningEnabled=0"
bcdedit /enum {current} | findstr /I /R /C:"^flightsigning *Yes$" >nul 2>&1
if %ERRORLEVEL% equ 0 set "FlightSigningEnabled=1"

:CHOICE_MENU
cls
set "WSH=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost"
set "cver=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
set "wdat=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows"
echo ============================================================
echo * OfflineInsiderEnroll v%scriptver% by nondetect aka aleks242007 *
echo *            Special thank's abbodi1406 ^& AveYo            *
echo ============================================================
echo.
echo  1 - %m1% Dev Channel
echo  2 - %m1% Beta Channel
echo  3 - %m1% Release Preview Channel
echo.
echo  4 - %m3%
echo  5 - %m4%
echo.
choice /C:12345 /N /M " %mch% [1,2,3,4,5] : "
if errorlevel 5 goto:EOF
if errorlevel 4 goto:STOP_INSIDER
if errorlevel 3 goto:ENROLL_RP
if errorlevel 2 goto:ENROLL_BETA
if errorlevel 1 goto:ENROLL_DEV

:ENROLL_DEV
set "Channel=Dev"
set "Fancy=Dev Channel"
set "BRL=2"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "actived=true"
set "activeb=false"
set "activerp=false"
goto :CHECK_CHOICE

:ENROLL_BETA
set "Channel=Beta"
set "Fancy=Beta Channel"
set "BRL=4"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "actived=false"
set "activeb=true"
set "activerp=false"
goto :CHECK_CHOICE

:ENROLL_RP
set "Channel=ReleasePreview"
set "Fancy=Release Preview Channel"
set "BRL=8"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "actived=false"
set "activeb=false"
set "activerp=true"
goto :CHECK_CHOICE

:CHECK_CHOICE
echo.
echo %m2%
echo.
choice /C:12 /N /M "%mch% [1,2] : "
if errorlevel 2 goto:ENROLL
if errorlevel 1 goto:ENROLL_SKIP_CHECK


:RESET_INSIDER_CONFIG
reg delete "%WSH%\Account" /f
reg delete "%WSH%\Applicability" /f
reg delete "%WSH%\Cache" /f
reg delete "%WSH%\UI" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\WUMUDCat" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\Ring%Ring%" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingExternal" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingPreview" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingInsiderSlow" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingInsiderFast" /f
reg delete "%cver%\Policies\DataCollection" /f /v AllowTelemetry
reg delete "%cdat%\DataCollection" /f /v AllowTelemetry
reg delete "%cdat%\WindowsUpdate" /f /v BranchReadinessLevel
goto :EOF

:ADD_INSIDER_CONFIG
reg add "%cver%\WindowsUpdate\Orchestrator" /f /t REG_DWORD /v EnableUUPScan /d 1
reg add "%cver%\WindowsUpdate\SLS\Programs\Ring%Ring%" /f /t REG_DWORD /v Enabled /d 1
reg add "%cver%\WindowsUpdate\SLS\Programs\WUMUDCat" /f /t REG_DWORD /v WUMUDCATEnabled /d 1
reg add "%cver%\Policies\DataCollection" /f /t REG_DWORD /v AllowTelemetry /d 3
if defined BRL reg add "%cdat%\WindowsUpdate" /f /t REG_DWORD /v BranchReadinessLevel /d %BRL%
reg add "%WSH%\Applicability" /f /t REG_DWORD /v EnablePreviewBuilds /d 2
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsBuildFlightingEnabled /d 1
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsConfigSettingsFlightingEnabled /d 1
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsConfigExpFlightingEnabled /d 0
reg add "%WSH%\Applicability" /f /t REG_DWORD /v TestFlags /d 32
reg add "%WSH%\Applicability" /f /t REG_DWORD /v RingId /d %RID%
reg add "%WSH%\Applicability" /f /t REG_SZ /v Ring /d "%Ring%"
reg add "%WSH%\Applicability" /f /t REG_SZ /v ContentType /d "%Content%"
reg add "%WSH%\Applicability" /f /t REG_SZ /v BranchName /d "%Channel%"
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIRing /d "%Ring%"
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIContentType /d "%Content%"
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIBranch /d "%Channel%"
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIDisabledElements_Rejuv /d 65517
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIHiddenElements_Rejuv /d 65508
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIErrorMessageVisibility /d 192
reg add "%WSH%\Cache" /f /t REG_SZ /v "ConfigurationOptionList" /d "{\"ConfigurationOptionList\":[{\"Name\":\"Dev\",\"Alias\":\"Dev Channel\",\"Description\":\"%cdevdesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Dev\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%actived%,\"Title\":\"Dev\",\"Warning\":\"%cdevwar%\"},{\"Name\":\"Beta\",\"Alias\":\"Beta Channel (Recommended)\",\"Description\":\"%cbetadesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Beta\",\"Ring\":\"External\",\"IsRecommended\":true,\"RecommendedOnly\":false,\"IsValid\":%activeb%,\"Title\":\"Beta\",\"Warning\":\"\"},{\"Name\":\"ReleasePreview\",\"Alias\":\"Release Preview Channel\",\"Description\":\"%crpdesk%\",\"ContentType\":\"Mainline\",\"Branch\":\"ReleasePreview\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%activerp%,\"Title\":\"Release Preview\",\"Warning\":\"\"}]}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "AccountText" /d "{\"Description\":\"%acdesc%\",\"Title\":\"%actitle%\",\"ButtonTitle\":\"%acbutton%\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "DeviceStatusBarText" /d "{\"Subtitle\":\"%dsdesk%\",\"LinkTitle\":\"%dsltitle%\",\"LinkUrl\":\"https://aka.ms/%Channel%Latest\",\"ButtonUrl\":\"ms-settings:about\",\"Status\":1,\"Title\":\"%dstitle%\",\"ButtonTitle\":\"%dsbutton%\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "ConfigurationExpanderText_Rejuv" /d "{\"Title\":\"%conftitle%\",\"RelatedLinkText\":\"%confrlink%\",\"RelatedLinkUrl\":\"https://github.com/nondetect/offlineinsiderenroll/releases\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "UnenrollText_Rejuv" /d "{\"Status\":\"\",\"ToggleTitle\":\"%unrtogtitle%\",\"ToggleDescription\":\"%unrtogdesk%\",\"LinkTitle\":\"%unrlinktitle%\",\"LinkDescription\":\"%unrlinkdesk%\",\"LinkUrl\":\"https://go.microsoft.com/fwlink/?linkid=2136438\",\"Title\":\"%unrtitle%\",\"RelatedLinkText\":\"%unrreltext%\",\"RelatedLinkUrl\":\"https://insider.windows.com/leave-program\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v StickyXaml /d "<StackPanel xmlns="^""http://schemas.microsoft.com/winfx/2006/xaml/presentation"^""><TextBlock Margin="^""0,10,0,0"^"" Style="^""{StaticResource BodyTextBlockStyle}"^"">%mdesc% v%scriptver%. %confrlink%. <Hyperlink NavigateUri="^""https://github.com/nondetect/offlineinsiderenroll/releases"^"" TextDecorations="^""None"^"">%lm%</Hyperlink></TextBlock><TextBlock Margin="^""0,10,0,5"^"" Style="^""{StaticResource SubtitleTextBlockStyle}"^""><Run FontFamily="^""Segoe MDL2 Assets"^"">&#xECA7;</Run> <Span FontWeight="^""SemiBold"^"">%aco%</Span></TextBlock><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^""><Span FontWeight="^""SemiBold"^"">%Fancy%</Span></TextBlock><TextBlock Text="^""Channel: %Channel%"^"" Style="^""{StaticResource BodyTextBlockStyle }"^"" /><TextBlock Text="^""Content: %Content%"^"" Style="^""{StaticResource BodyTextBlockStyle }"^"" /><TextBlock Margin="^""0,10,0,0"^"" Style="^""{StaticResource SubtitleTextBlockStyle}"^""><Run FontFamily="^""Segoe MDL2 Assets"^"">&#xE9D9;</Run> <Span FontWeight="^""SemiBold"^"">%mnottitle%</Span></TextBlock><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"">%mnotdesk1% <Span FontWeight="^""SemiBold"^"">%mnotdesk2%</Span>%mnotdesk3% <Span FontWeight="^""SemiBold"^"">%mnotdesk4%</Span>.</TextBlock><Button Command="^""{StaticResource ActivateUriCommand}"^"" CommandParameter="^""ms-settings:privacy-feedback"^"" Margin="^""0,10,0,20"^""><TextBlock Margin="^""5,0,5,0"^"">%mnotbutton%</TextBlock></Button></StackPanel>"
chcp 1251 >nul
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings]
echo "StickyMessage"="{\"Message\":\"%mtitle%\",\"LinkTitle\":\"%lm%\",\"LinkUrl\":\"https://github.com/nondetect/offlineinsiderenroll/blob/master/readme.md\",\"DynamicXaml\":\"^<StackPanel xmlns=\\\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\\\"^>^<TextBlock Margin=\\\"0,-25,0,10\\\" Style=\\\"{StaticResource BodyTextBlockStyle }\\\"^>%mdesc% v%scriptver%.^</TextBlock^>^<TextBlock Style=\\\"{StaticResource SubtitleTextBlockStyle }\\\" ^>^<Run FontFamily=\\\"Segoe Fluent Icons\\\"^>^&#xE9D9;^</Run^> ^<Span FontWeight=\\\"SemiBold\\\"^>%mnottitle%^</Span^>^</TextBlock^>^<TextBlock Style=\\\"{StaticResource BodyTextBlockStyle }\\\"^>%mnotdesk1% ^<Span FontWeight=\\\"SemiBold\\\"^>%mnotdesk2%^</Span^>%mnotdesk3% ^<Span FontWeight=\\\"SemiBold\\\"^>%mnotdesk4%^</Span^>.^</TextBlock^>^<Button Command=\\\"{StaticResource ActivateUriCommand}\\\" CommandParameter=\\\"ms-settings:privacy-feedback\\\" Margin=\\\"0,10,0,0\\\"^>^<TextBlock Margin=\\\"5,0,5,0\\\"^>%mnotbutton%^</TextBlock^>^</Button^>^</StackPanel^>\",\"Severity\":0}"
echo.
)>"%Temp%\oie.reg"
regedit /s "%Temp%\oie.reg"
del /f /q "%Temp%\oie.reg"
goto :EOF

:SKIP_CHECK
cls
echo.
echo: $_Paste_in_Powershell = { $:code;  
echo:  $N = 'Skip TPM Check on Dynamic Update'; $toggle = $null -eq $env:skip_tpm_enabled; $off = $false
echo:   $P = ^"$([environment]::SystemDirectory)\cmd.exe^"; $T = ^"$P /q $N (c) AveYo, 2021 /d /rerase appraiserres.dll /f /s /q^"
echo:   $D = ^"$($P[0]):\`$WINDOWS.~BT^"; $Q = ^"SELECT SessionID from Win32_ProcessStartTrace WHERE ProcessName='vdsldr.exe'^"
echo:   $F = Set-WMIInstance -Class __EventFilter -NameSpace 'root\subscription' -args @{ Name = $N; EventNameSpace = 'root\cimv2'; QueryLanguage = 'WQL'; Query = $Q} -PutType 2 -ea 0
echo:   $C = Set-WMIInstance -Class CommandLineEventConsumer -Namespace 'root\subscription' -args @{ Name = $N; WorkingDirectory = $D; ExecutablePath = $P; CommandLineTemplate = $T; Priority = 128} -PutType 2 -ea 0
echo:   $B = Set-WMIInstance -Class __FilterToConsumerBinding -Namespace 'root\subscription' -args @{Filter=$F;Consumer=$C} -PutType 2 -ea 0
echo:  if ($toggle) { write-host -fore 0xf -back 0x2 ^"`n $N [INSTALLED]^"; timeout /t 0} ; $:code;
echo: } ; Start-Process -verb runas powershell -args ^"-nop -c ^& {`n`n$($_Paste_in_Powershell-replace'^"','\^"')}^"
goto :EOF

:REMOVE_SKIP_CHECK
cls
echo.
echo: $_Paste_in_Powershell = { $:code;  
echo:  $N = 'Skip TPM Check on Dynamic Update'; $toggle = $null -eq $env:skip_tpm_enabled; $off = $false
echo:   $B = Get-WmiObject -Class __FilterToConsumerBinding -Namespace 'root\subscription' -Filter ^"Filter = ^"^"__eventfilter.name='$N'^"^"^" -ea 0
echo:   $C = Get-WmiObject -Class CommandLineEventConsumer -Namespace 'root\subscription' -Filter ^"Name='$N'^" -ea 0
echo:   $F = Get-WmiObject -Class __EventFilter -NameSpace 'root\subscription' -Filter ^"Name='$N'^" -ea 0
echo:   if ($B -or $C -or $F) { $B ^| Remove-WMIObject; $C ^| Remove-WMIObject; $F ^| Remove-WMIObject; $off = $true }
echo:   if ($toggle -and $off) { write-host -fore 0xf -back 0xd ^"`n $N [REMOVED]^"; timeout /t 0; return }
echo: } ; Start-Process -verb runas powershell -args ^"-nop -c ^& {`n`n$($_Paste_in_Powershell-replace'^"','\^"')}^"
goto :EOF

:ENROLL
echo.
echo %apc%
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
call :ADD_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /set {current} flightsigning yes >nul 2>&1
echo %apd%
echo.
if %FlightSigningEnabled% neq 1 goto :ASK_FOR_REBOOT
echo %pte%
pause >nul
goto :EOF

:ENROLL_SKIP_CHECK
echo.
echo %apc%
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
call :ADD_INSIDER_CONFIG 1>NUL 2>NUL
call :SKIP_CHECK >%temp%\oie.ps1
powershell -command " & { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; %temp%\oie.ps1 }" 1>NUL 2>NUL
bcdedit /set {current} flightsigning yes >nul 2>&1
echo %apd%
del /f /q "%Temp%\oie.ps1" 1>NUL 2>NUL
echo.
if %FlightSigningEnabled% neq 1 goto :ASK_FOR_REBOOT
echo %pte%
pause >nul
goto :EOF

:STOP_INSIDER
echo %apc%
call :RESET_INSIDER_CONFIG 1>nul 2>nul
call :REMOVE_SKIP_CHECK >%temp%\oie.ps1
powershell -command " & { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; %temp%\oie.ps1 }" 1>NUL 2>NUL
bcdedit /deletevalue {current} flightsigning >nul 2>&1
echo %apd%
del /f /q "%Temp%\oie.ps1" 1>NUL 2>NUL
echo.
if %FlightSigningEnabled% neq 0 goto :ASK_FOR_REBOOT
echo %pte%
pause >nul
goto :EOF

:ASK_FOR_REBOOT
set "choice="
echo %rtitle%
set /p choice="%rdesk% (y/N): "
if /I "%choice%"=="y" shutdown -r -t 0
goto :EOF

:RU_LOCALE
echo %lang% in ru
set "chadmin=Необходимо запускать от имени Администратора"
set "chbuild=Ваша текущая сборка %build%. Для работы скрипта необходима версия Windows 10 v1809 сборка 17763 или выше"
set "m1=Перейти на"
set "m2=Отключить проверку совместимости? 1 - Да 2 - Нет."
set "m3=Прекратить получение Инсайдерских сборок"
set "m4=Выход без внесения изменений"
set "mch=Введите свой выбор"
set "apc=Применение изменений..."
set "apd=Готово"
set "pte=Нажмите любую кнопку для выхода"
set "rtitle=Необходима перезагрузка чтобы изменения вступили в силу"
set "rdesk=Хотите перезагрузить компьютер"
set "actitle=Учетная запись участника программы предварительной оценки Windows"
set "acdesc=Нет привязанной учётной записи"
set "acbutton=Изменить"
set "cdevdesc=Идеально подходит для технически подкованных пользователей. Первыми получайте доступ к новейшим сборкам Windows 11 на самом раннем этапе цикла разработки с новейшим кодом. Вы заметите некоторые шероховатости и низкую стабильность."
set "cdevwar=Мы рекомендуем Dev Channel только в том случае, если вы активно выполняете резервное копирование данных и вам комфортно выполнять чистую установку Windows. Этот канал получает сборки, которые имеют некоторые шероховатости и могут быть нестабильными. После установки сборки из Dev Channel единственный способ перейти на другой канал или отменить регистрацию этого устройства - это выполнить чистую установку Windows. Вам нужно будет вручную создать резервную копию и восстановить все данные, которые вы хотите сохранить."
set "cbetadesc=Идеально подходит для ранних последователей. Эти сборки Windows 11 более надежны, чем сборки из канала Dev, благодаря обновлениям, проверяемым корпорацией Microsoft. Ваш отзыв оказывает значительное воздействие."
set "crpdesk=Идеально подходит, если вы хотите ознакомиться с исправлениями и некоторыми ключевыми функциями, а также получить возможность доступа к следующей версии Windows, прежде чем она станет общедоступной для всего мира. Этот канал также рекомендуется для коммерческих пользователей."
set "dstitle=На вашем устройстве установлена новейшая версия сборки"
set "dsdesk=Информация о текущей версии доступна в разделе Система - О системе"
set "dsltitle=Последние изменения в сборке"
set "dsbutton=Открыть О системе"
set "conftitle=Посмотреть текущие параметры программы предварительной оценки"
set "confrlink=Если хотите изменить настройки Windows Insider или прекратить участие, пожалуйста используйте скрипт"
set "lm=Узнать больше"
set "mtitle=Устройство зарегистрировано с помощью OfflineInsiderEnroll"
set "mdesc=Это устройство было зарегистрировано в программе предварительной оценки Windows с помощью OfflineInsiderEnroll"
set "aco=Выбранные настройки"
set "mnottitle=Уведомление о настройках телеметрии"
set "mnotdesk1=Программа предварительной оценки Windows требует, чтобы в настройках сбора диагностических данных была включена"
set "mnotdesk2=Отправка необязательных диагностических данных."
set "mnotdesk3=Вы можете проверить или изменить свои текущие настройки в"
set "mnotdesk4=Диагностика и отзывы"
set "mnotbutton=Открыть Диагностика и отзывы"
set "unrtitle=Прекратить получение предварительных сборок"
set "unrtogtitle=Отменить регистрацию этого устройства после выхода следующей версии Windows"
set "unrtogdesk=Доступно для каналов бета-версии и предварительного выпуска. Включите этот параметр, чтобы прекратить получение предварительных сборок после запуска следующего общедоступного основного выпуска Windows. До этого момента ваше устройство будет получать сборки для предварительной оценки, чтобы поддерживать его безопасность. Все ваши приложения, драйверы и параметры будут сохранены даже после того, как вы перестанете получать предварительные сборки."
set "unrlinktitle=Быстрая отмена регистрации устройства"
set "unrlinkdesk=Чтобы прекратить получение сборок Insider Preview на устройстве, выполните чистую установку последней версии Windows. Примечание. При этом будут удалены все ваши данные и установлена свежая копия Windows."
set "unrreltext=Выход из программы предварительной оценки Windows"
goto :CHECK_BUILD

:EN_LOCALE
echo %lang% in en
set "chadmin=This script needs to be executed as an administrator."
set "chbuild=Your build is %build%. This script is compatible only with Windows 10 v1809 build 17763 and later."
set "m1=Enroll to"
set "m2=Disable compatibility checker? 1 - Yes 2 - No."
set "m3=Stop receiving Insider Preview builds"
set "m4=Quit without making any changes"
set "mch=Enter Your Choice"
set "apc=Applying changes..."
set "apd=Done"
set "pte=Press any key to exit."
set "rtitle=A reboot is required to finish applying changes."
set "rdesk=Would you like to reboot your PC?"
set "actitle=Windows Insider account"
set "acdesc=No account linked"
set "acbutton=Edit"
set "cdevdesc=Ideal for highly technical users. Be the first to access the latest Windows 11 builds earliest in the development cycle with the newest code. There will be some rough edges and low stability."
set "cdevwar=We recommend the Dev Channel only if you actively back up your data and are comfortable clean installing Windows. This channel receives builds that may have rough edges or be unstable. Once you install a build from the Dev Channel, the only way to move to another channel or unenroll this device is to clean install Windows. You?ll need to manually back up and restore any data you want to keep."
set "cbetadesc=Ideal for early adopters. These Windows 11 builds will be more reliable than builds from our Dev Channel, with updates validated by Microsoft. Your feedback has the greatest impact here."
set "crpdesk=Ideal if you want to preview fixes and certain key features, plus get optional access to the next version of Windows before it's generally available to the world. This channel is also recommended for commercial users."
set "dstitle=You're on the latest build for your device"
set "dsdesk=Information about the current version is available in the section System - About"
set "dsltitle=Latest build notes"
set "dsbutton=Open About System"
set "conftitle=Your Insider settings"
set "confrlink=If you want to change settings of the enrollment or stop receiving Insider Preview builds, please use the script."
set "lm=Learn more"
set "mtitle=Device Enrolled using OfflineInsiderEnroll"
set "mdesc=This device has been enrolled to the Windows Insider program using OfflineInsiderEnroll"
set "aco=Applied configuration"
set "mnottitle=Telemetry settings notice"
set "mnotdesk1=Windows Insider Program requires diagnostic data collection to be enabled "
set "mnotdesk2=Send optional diagnostic data"
set "mnotdesk3=. You can verify or modify your current settings in "
set "mnotdesk4=Diagnostics and feedback"
set "mnotbutton=Open Diagnostics and feedback"
set "unrtitle=Stop getting preview builds"
set "unrtogtitle=Unenroll this device when the next version of Windows releases"
set "unrtogdesk=Available for Beta and Release Preview channels. Turn this on to stop getting preview builds when the next major release of Windows launches to the public. Until then, your device will continue to get Insider builds to keep it secure. You'll keep all your apps, drivers and settings even after you stop getting preview builds."
set "unrlinktitle=Unenroll this device immediately"
set "unrlinkdesk=To stop getting Insider Preview builds on this device, you'll need to clean install the latest release of Windows. Note: This option will erase all your data and install a fresh copy of Windows."
set "unrreltext=Leaving the Insider Program"
goto :CHECK_BUILD