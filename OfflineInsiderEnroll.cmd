@echo off

for /f "tokens=3" %%b in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildBranch"') do set br=%%b 
set "locale=ru"
for /f "tokens=3 delims=;:- " %%l in ('systeminfo ^| findstr /b /c:"System Locale:"') do set lang=%%l 
for /f "tokens=3 delims=;:- " %%l in ('systeminfo ^| findstr /b /c:"Язык системы:"') do set lang=%%l
if /I %lang%==%locale%  ( goto :RU_LOCALE ) else ( goto :EN_LOCALE )

:CHECK_BUILD
for /f "tokens=4 delims=[] " %%i in ('ver') do set build=%%i
if %build:~5,5% LSS 17763 (
    echo =============================================================
    echo %chbuild1% %build:~5%. %chbuild2%
    echo =============================================================
    echo.
    pause
    goto :EOF
) else ( 
    goto :CHECK_ADMIN 
    )

:CHECK_ADMIN
REG QUERY HKU\S-1-5-19\Environment >NUL 2>&1
IF %ERRORLEVEL% EQU 0 goto :START_SCRIPT
echo =====================================================
echo %chadmin%
echo =====================================================
echo.
pause
goto :EOF

:RU_LOCALE
echo %lang% in ru
set "chadmin=Необходимо запускать от имени Администратора"
set "chbuild1=Ваша текущая сборка"
set "chbuild2=Для работы скрипта необходима весия Windows 10 v1809 сборка 17763 или выше"
set "m1=Перейти на"
set "m2=Прекратить получение Инсайдерских сборок"
set "m3=Выход без внесения изменений"
set "mch=Введите свой выбор"
set "apc=Применение изменений..."
set "apd=Готово"
set "rtitle=Необходима перезагрузка чтобы изменения вступили в силу"
set "rdesk=Хотите перезагрузить компьютер"
set "actitle=Учетная запись участника программы предварительной оценки Windows"
set "acdesc=Нет привязанной учётной записи"
set "acbutton=Изменить"
set "cdevdesc=Идеально подходит для технически подкованных пользователей. Первыми получайте доступ к новейшим сборкам Windows 11 на самом раннем этапе цикла разработки с новейшим кодом. Вы заметите некоторые шероховатости и низкую стабильность."
set "cdevwar=Мы рекомендуем Dev Channel только в том случае, если вы активно выполняете резервное копирование данных и вам комфортно выполнять чистую установку Windows. Этот канал получает сборки, которые имеют некоторые шероховатости и могут быть нестабильными. После установки сборки из Dev Channel единственный способ перейти на другой канал или отменить регистрацию этого устройства - это выполнить чистую установку Windows. Вам нужно будет вручную создать резервную копию и восстановить все данные, которые вы хотите сохранить."
set "cbetadesc=Идеально подходит для ранних последователей. Эти сборки Windows 11 более надежны, чем сборки из канала Dev, благодаря обновлениям, проверяемым корпорацией Майкрософт. Ваш отзыв оказывает значительное воздействие."
set "crpdesk=Идеально подходит, если вы хотите ознакомиться с исправлениями и некоторыми ключевыми функциями, а также получить возможность доступа к следующей версии Windows 10, прежде чем она станет общедоступной для всего мира. Этот канал также рекомендуется для коммерческих пользователей."
set "dstitle=На вашем устройстве установлена новейшая версия сборки"
set "dsdesk=Установлена сборка:"
set "dsltitle=Последние изменения в сборке"
set "dsbutton=Оставить отзыв"
set "conftitle=Посмотреть текущие параметры программы предварительной оценки"
set "confrlink=Если хотите изменить настройки Windows Insider или прекратить участие, пожалуйста используйте скрипт"
set "mtitle=Устройство зарегистрировано с помощь OfflineInsiderEnroll"
set "mdesc=Это устройство было зарегистрировано в программе предварительной оценки Windows с помощью OfflineInsiderEnroll"
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
set "unrlinkdesk=Чтобы прекратить получение сборок Insider Preview на устройстве, выполните чистую установку последней версии Windows 10. Примечание. При этом будут удалены все ваши данные и установлена свежая копия Windows 10."
set "unrreltext=Выход из программы предварительной оценки Windows"
goto :CHECK_BUILD

:EN_LOCALE
echo %lang% in en
set "chadmin=This script needs to be executed as an administrator."
set "chbuild1=Your build is"
set "chbuild2=This script is compatible only with Windows 10 RS5 17763 and later."
set "m1=Enroll to"
set "m2=Stop receiving Insider Preview builds"
set "m3=Quit without making any changes"
set "mch=Enter Your Choice"
set "apc=Applying changes..."
set "apd=Done"
set "rtitle=A reboot is required to finish applying changes."
set "rdesk=Would you like to reboot your PC?"
set "actitle=Windows Insider account"
set "acdesc=No account linked"
set "acbutton=Edit"
set "cdevdesc=Ideal for highly technical users. Be the first to access the latest Windows 11 builds earliest in the development cycle with the newest code. There will be some rough edges and low stability."
set "cdevwar=We recommend the Dev Channel only if you actively back up your data and are comfortable clean installing Windows. This channel receives builds that may have rough edges or be unstable. Once you install a build from the Dev Channel, the only way to move to another channel or unenroll this device is to clean install Windows. You?ll need to manually back up and restore any data you want to keep."
set "cbetadesc=Ideal for early adopters. These Windows 11 builds will be more reliable than builds from our Dev Channel, with updates validated by Microsoft. Your feedback has the greatest impact here."
set "crpdesk=Ideal if you want to preview fixes and certain key features, plus get optional access to the next version of Windows 10 before it's generally available to the world. This channel is also recommended for commercial users."
set "dstitle=You're on the latest build for your device"
set "dsdesk=Installed build:"
set "dsltitle=Latest build notes"
set "dsbutton=Give feedback"
set "conftitle=Your Insider settings"
set "confrlink=If you want to change settings of the enrollment or stop receiving Insider Preview builds, please use the script."
set "mtitle=Device Enrolled using OfflineInsiderEnroll"
set "mdesc=This device has been enrolled to the Windows Insider program using OfflineInsiderEnroll"
set "mnottitle=Telemetry settings notice"
set "mnotdesk1=Windows Insider Program requires diagnostic data collection to be enabled "
set "mnotdesk2=Send optional diagnostic data. "
set "mnotdesk3=You can verify or modify your current settings in "
set "mnotdesk4=Diagnostics &amp; feedback"
set "mnotbutton=Open Diagnostics &amp; feedback"
set "unrtitle=Stop getting preview builds"
set "unrtogtitle=Unenroll this device when the next version of Windows releases"
set "unrtogdesk=Available for Beta and Release Preview channels. Turn this on to stop getting preview builds when the next major release of Windows launches to the public. Until then, your device will continue to get Insider builds to keep it secure. You?ll keep all your apps, drivers and settings even after you stop getting preview builds."
set "unrlinktitle=Unenroll this device immediately"
set "unrlinkdesk=To stop getting Insider Preview builds on this device, you?ll need to clean install the latest release of Windows 10. Note: This option will erase all your data and install a fresh copy of Windows 10."
set "unrreltext=Leaving the Insider Program"
goto :CHECK_BUILD

:START_SCRIPT
set "scriptver=2.7.0_ml"
set "FlightSigningEnabled=0"
bcdedit /enum {current} | findstr /I /R /C:"^flightsigning *Yes$" >NUL 2>&1
IF %ERRORLEVEL% EQU 0 set "FlightSigningEnabled=1"

:CHOICE_MENU
cls
set "WSH=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost\"
echo OfflineInsiderEnroll v%scriptver%
echo.
echo 1 - %m1% Dev Channel
echo 2 - %m1% Beta Channel
echo 3 - %m1% Release Preview Channel
echo.
echo 4 - %m2%
echo 5 - %m3%
echo.
choice /C:12345 /N /M "%mch% [1,2,3,4,5] : "
if errorlevel 5 goto:EOF
if errorlevel 4 goto:STOP_INSIDER
if errorlevel 3 goto:ENROLL_RP
if errorlevel 2 goto:ENROLL_BETA
if errorlevel 1 goto:ENROLL_DEV


:ENROLL_RP
set "Channel=ReleasePreview"
set "Fancy=Release Preview Channel"
set "BRL=8"
set "actived=false"
set "activeb=false"
set "activerp=true"
goto :ENROLL

:ENROLL_BETA
set "Channel=Beta"
set "Fancy=Beta Channel"
set "BRL=4"
set "actived=false"
set "activeb=true"
set "activerp=false"
goto :ENROLL

:ENROLL_DEV
set "Channel=Dev"
set "Fancy=Dev Channel"
set "BRL=2"
set "actived=true"
set "activeb=false"
set "activerp=false"
goto :ENROLL

:RESET_INSIDER_CONFIG
reg delete "%WSH%Account" /f
reg delete "%WSH%Applicability" /f
reg delete "%WSH%Cache" /f
reg delete "%WSH%UI" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\WUMUDCat" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingExternal" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingPreview" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingInsiderSlow" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingInsiderFast" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v BranchReadinessLevel /f
goto :EOF

:ADD_INSIDER_CONFIG
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator" /t REG_DWORD /v EnableUUPScan /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\RingExternal" /t REG_DWORD /v Enabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\SLS\Programs\WUMUDCat" /t REG_DWORD /v WUMUDCATEnabled /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /t REG_DWORD /v AllowTelemetry /d 3 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /t REG_DWORD /v BranchReadinessLevel /d %BRL% /f
reg add "%WSH%Applicability" /t REG_DWORD /v EnablePreviewBuilds /d 2 /f
reg add "%WSH%Applicability" /t REG_DWORD /v IsBuildFlightingEnabled /d 1 /f
reg add "%WSH%Applicability" /t REG_DWORD /v IsConfigSettingsFlightingEnabled /d 1 /f
reg add "%WSH%Applicability" /t REG_DWORD /v TestFlags /d 32 /f
reg add "%WSH%Applicability" /t REG_DWORD /v RingId /d 11 /f
reg add "%WSH%Applicability" /t REG_SZ /v Ring /d "External" /f
reg add "%WSH%Applicability" /t REG_SZ /v ContentType /d "Mainline" /f
reg add "%WSH%Applicability" /t REG_SZ /v BranchName /d "%Channel%" /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIHiddenElements /d 65535 /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIDisabledElements /d 65535 /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIServiceDrivenElementVisibility /d 0 /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIErrorMessageVisibility /d 192 /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIHiddenElements_Rejuv /d 65508 /f
reg add "%WSH%UI\Visibility" /t REG_DWORD /v UIDisabledElements_Rejuv /d 65517 /f
reg add "%WSH%UI\Selection" /t REG_SZ /v UIBranch /d "%Channel%" /f
reg add "%WSH%UI\Selection" /t REG_SZ /v UIContentType /d "Mainline" /f
reg add "%WSH%UI\Selection" /t REG_SZ /v UIRing /d "External" /f
reg add "%WSH%Cache" /t REG_SZ /v "ConfigurationOptionList" /d "{\"ConfigurationOptionList\":[{\"Name\":\"Dev\",\"Alias\":\"Dev Channel\",\"Description\":\"%cdevdesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Dev\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%actived%,\"Title\":\"Dev\",\"Warning\":\"%cdevwar%\"},{\"Name\":\"Beta\",\"Alias\":\"Beta Channel (Recommended)\",\"Description\":\"%cbetadesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Beta\",\"Ring\":\"External\",\"IsRecommended\":true,\"RecommendedOnly\":false,\"IsValid\":%activeb%,\"Title\":\"Beta\",\"Warning\":\"\"},{\"Name\":\"ReleasePreview\",\"Alias\":\"Release Preview Channel\",\"Description\":\"%crpdesk%\",\"ContentType\":\"Mainline\",\"Branch\":\"ReleasePreview\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%activerp%,\"Title\":\"Release Preview\",\"Warning\":\"\"}]}" /f 
reg add "%WSH%UI\Strings" /t REG_SZ /v "AccountText" /d "{\"Description\":\"%acdesc%\",\"Title\":\"%actitle%\",\"ButtonTitle\":\"%acbutton%\"}" /f
reg add "%WSH%UI\Strings" /t REG_SZ /v "DeviceStatusBarText" /d "{\"Subtitle\":\"%dsdesk% %build:~5% %br% \",\"LinkTitle\":\"%dsltitle%\",\"LinkUrl\":\"https://aka.ms/%Channel%Latest\",\"ButtonUrl\":\"feedback-hub://\",\"Status\":1,\"Title\":\"%dstitle%\",\"ButtonTitle\":\"%dsbutton%\"}" /f
reg add "%WSH%UI\Strings" /t REG_SZ /v "ConfigurationExpanderText_Rejuv" /d "{\"Title\":\"%conftitle%\",\"RelatedLinkText\":\"%confrlink%\",\"RelatedLinkUrl\":\"https://github.com/abbodi1406/offlineinsiderenroll/blob/master/readme.md\"}" /f
reg add "%WSH%UI\Strings" /t REG_SZ /v StickyMessage /d "{"^""Message"^"":"^""%mtitle%"^"","^""LinkTitle"^"":"^"""^"","^""LinkUrl"^"":"^"""^"","^""DynamicXaml"^"":"^""<StackPanel xmlns=\\"^""http://schemas.microsoft.com/winfx/2006/xaml/presentation\\"^""><TextBlock Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"" Margin=\\"^""0,-25,0,10\\"^"">%mdesc% v%scriptver%. </TextBlock><TextBlock Text=\\"^""%mnottitle%\\"^"" Margin=\\"^""0,0,0,10\\"^"" Style=\\"^""{StaticResource SubtitleTextBlockStyle}\\"^"" /><TextBlock Style=\\"^""{StaticResource BodyTextBlockStyle }\\"^"">%mnotdesk1% <Span FontWeight=\\"^""SemiBold\\"^"">%mnotdesk2%</Span> %mnotdesk3% <Span FontWeight=\\"^""SemiBold\\"^"">%mnotdesk4%</Span>.</TextBlock><Button Command=\\"^""{StaticResource ActivateUriCommand}\\"^"" CommandParameter=\\"^""ms-settings:privacy-feedback\\"^"" Margin=\\"^""0,10,0,0\\"^""><TextBlock Margin=\\"^""5,0,5,0\\"^"">%mnotbutton%</TextBlock></Button></StackPanel>"^"","^""Severity"^"":0}" /f
if %build:~5,5% LSS 21990 reg add "%WSH%UI\Strings" /t REG_SZ /v StickyXaml /d "<StackPanel xmlns="^""http://schemas.microsoft.com/winfx/2006/xaml/presentation"^""><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"" Margin="^""0,-25,0,10"^"">%mdesc% v%scriptver%.</TextBlock><TextBlock Text="^""%mnottitle%"^"" Margin="^""0,0,0,10"^"" Style="^""{StaticResource SubtitleTextBlockStyle}"^"" /><TextBlock Style="^""{StaticResource BodyTextBlockStyle }"^"">%mnotdesk1% <Span FontWeight="^""SemiBold"^"">%mnotdesk2%</Span> %mnotdesk3% <Span FontWeight="^""SemiBold"^"">%mnotdesk4%</Span>.</TextBlock><Button Command="^""{StaticResource ActivateUriCommand}"^"" CommandParameter="^""ms-settings:privacy-feedback"^"" Margin="^""0,10,0,0"^""><TextBlock Margin="^""5,0,5,0"^"">%mnotbutton%</TextBlock></Button></StackPanel>" /f
reg add "%WSH%UI\Strings" /t REG_SZ /v "UnenrollText_Rejuv" /d "{\"Status\":\"\",\"ToggleTitle\":\"%unrtogtitle%\",\"ToggleDescription\":\"%unrtogdesk%\",\"LinkTitle\":\"%unrlinktitle%\",\"LinkDescription\":\"%unrlinkdesk%\",\"LinkUrl\":\"https://go.microsoft.com/fwlink/?linkid=2136438\",\"Title\":\"%unrtitle%\",\"RelatedLinkText\":\"%unrreltext%\",\"RelatedLinkUrl\":\"https://insider.windows.com/leave-program\"}" /f
goto :EOF

:ENROLL
echo %apc%
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
call :ADD_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /set {current} flightsigning yes >NUL 2>&1
echo %apd%.

echo.
IF %FlightSigningEnabled% NEQ 1 goto :ASK_FOR_REBOOT
pause
goto :EOF

:STOP_INSIDER
echo %apc%
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /deletevalue {current} flightsigning >NUL 2>&1
echo %apd%.

echo.
IF %FlightSigningEnabled% NEQ 0 goto :ASK_FOR_REBOOT
pause
goto :EOF

:ASK_FOR_REBOOT
set "choice="
echo %rtitle%
set /p choice="%rdesk% (y/N): "
if /I "%choice%"=="y" shutdown -r -t 0 
goto :EOF