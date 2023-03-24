@echo off
set "scriptver=2.9.8"
title ORM-Insider %scriptver%
mode con:cols=90 lines=24
chcp 866 >nul
goto :LOCALE

:CHECKS
color a
if %build:~0,5% LSS %defbuild% (
echo.%agrd%
echo.%agre%
echo.%chbuild%
echo.%agre%
echo.                          %os% %build%
echo.%agre%
echo.%agrd%
echo.%pte%
echo.%agrd%
pause >nul
goto :EOF ) 

net session >nul 2>&1
if %ERRORLEVEL% equ 0 goto :AGREEMENT
echo.%agrd%
echo.%agre%
echo.%chadmin%
echo.%agre%
echo.%agrd%
echo.%pte%
echo.%agrd%
pause >nul
goto :EOF 

:START_SCRIPT
call :D_SKIP
set "FlightSigningEnabled=0"
bcdedit /enum {current} | findstr /I /R /C:"^flightsigning *Yes$" >nul 2>&1
if %ERRORLEVEL% equ 0 set "FlightSigningEnabled=1"
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SetupHost.exe" /ve >nul
IF %errorlevel% EQU 0 (set "mcr=%ESC%[41;30m %mcd% %ESC%[40;32m") else (set "mcr=%ESC%[42;30m %mce% %ESC%[40;32m")
cls
color 2
set "WSH=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsSelfHost"
set "cver=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
set "wdat=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows"
echo.%agrd%
echo.^|                      ORM-Insider v%scriptver% by nondetect aka aleks242007                   ^|
echo.^|                            Special thank's abbodi1406 ^& AveYo                          ^|
echo.%agrd%
echo.%me%1] - %m1% Canary Channel
echo.%agre%
echo.%me%2] - %m1% Dev Channel
echo.%agre%
echo.%me%3] - %m1% Beta Channel
echo.%agre%
echo.%me%4] - %m1% Release Preview Channel
echo.%agrs%
echo.                        %mcc% [%mkc%] - %mcr% 
echo.%agrs%
echo.%me%%m2%
echo.%agre%
echo.%me%%m3%
echo.%agrs%
echo.%me%%m4%
echo.%agre%
echo.%me%%m5%
echo.%agrs%
choice /C:12345678v /N /M "%mch% [1-8,v] : "
if errorlevel 9 goto:SWITCH 
if errorlevel 8 exit /b
if errorlevel 7 goto:STOP_INSIDER
if errorlevel 6 goto:EX_REMOVE_SKIP_CHECK
if errorlevel 5 goto:EX_SKIP_CHECK
if errorlevel 4 goto:ENROLL_RP
if errorlevel 3 goto:ENROLL_BETA
if errorlevel 2 goto:ENROLL_DEV
if errorlevel 1 goto:ENROLL_CANARY

:SWITCH
if "%mkc%"=="main" (
    set mkc=%mc8%
    set sk_l=%sk_v8%
) else (
    set mkc=%mcm%
    set sk_l=%sk_m%
)
goto :START_SCRIPT

:ENROLL_CANARY
set "Channel=CanaryChannel"
set "uibr=Canary"
set "Fancy=Canary Channel"
set "BRL="
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "activec=true"
set "actived=false"
set "activeb=false"
set "activerp=false"
goto :ENROLL

:ENROLL_DEV
set "Channel=Dev"
set "uibr=Dev"
set "Fancy=Dev Channel"
set "BRL=2"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "activec=false"
set "actived=true"
set "activeb=false"
set "activerp=false"
goto :ENROLL

:ENROLL_BETA
set "Channel=Beta"
set "uibr=Beta"
set "Fancy=Beta Channel"
set "BRL=4"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "activec=false"
set "actived=false"
set "activeb=true"
set "activerp=false"
goto :ENROLL

:ENROLL_RP
set "Channel=ReleasePreview"
set "uibr=ReleasePreview"
set "Fancy=Release Preview Channel"
set "BRL=8"
set "Content=Mainline"
set "Ring=External"
set "RID=11"
set "activec=false"
set "actived=false"
set "activeb=false"
set "activerp=true"
goto :ENROLL

:RESET_INSIDER_CONFIG
reg delete "%WSH%\Account" /f
reg delete "%WSH%\Applicability" /f
reg delete "%WSH%\Cache" /f
reg delete "%WSH%\ClientState" /f
reg delete "%WSH%\UI" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\WUMUDCat" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\Ring%Ring%" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingExternal" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingPreview" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingInsiderSlow" /f
reg delete "%cver%\WindowsUpdate\SLS\Programs\RingInsiderFast" /f
reg delete "%cver%\Policies\DataCollection" /f /v AllowTelemetry
reg delete "%wdat%\DataCollection" /f /v AllowTelemetry
reg delete "%wdat%\WindowsUpdate" /f /v BranchReadinessLevel
goto :EOF

:ADD_INSIDER_CONFIG
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SetupHost.exe" /ve >nul
IF %errorlevel% EQU 0 (set "mcrt=%mcd%") else (set "mcrt=%mce%")
reg add "%cver%\WindowsUpdate\Orchestrator" /f /t REG_DWORD /v EnableUUPScan /d 1
reg add "%cver%\WindowsUpdate\SLS\Programs\Ring%Ring%" /f /t REG_DWORD /v Enabled /d 1
reg add "%cver%\WindowsUpdate\SLS\Programs\WUMUDCat" /f /t REG_DWORD /v WUMUDCATEnabled /d 1
reg add "%cver%\Policies\DataCollection" /f /t REG_DWORD /v AllowTelemetry /d 3
if defined BRL reg add "%wdat%\WindowsUpdate" /f /t REG_DWORD /v BranchReadinessLevel /d %BRL%
reg add "%WSH%\Applicability" /f /t REG_DWORD /v EnablePreviewBuilds /d 2
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsBuildFlightingEnabled /d 1
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsConfigSettingsFlightingEnabled /d 1
reg add "%WSH%\Applicability" /f /t REG_DWORD /v IsConfigExpFlightingEnabled /d 0
reg add "%WSH%\Applicability" /f /t REG_DWORD /v TestFlags /d 32
reg add "%WSH%\Applicability" /f /t REG_DWORD /v RingId /d %RID%
reg add "%WSH%\Applicability" /f /t REG_SZ /v Ring /d "%Ring%"
reg add "%WSH%\Applicability" /f /t REG_SZ /v ContentType /d "%Content%"
reg add "%WSH%\Applicability" /f /t REG_SZ /v BranchName /d "%Channel%"
reg add "%WSH%\ClientState" /f /t REG_DWORD /v PilotInfoRing /d 3
reg add "%WSH%\ClientState" /f /t REG_DWORD /v ErrorState /d 1
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIRing /d "%Ring%"
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIContentType /d "%Content%"
reg add "%WSH%\UI\Selection" /f /t REG_SZ /v UIBranch /d "%uibr%"
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIDisabledElements_Rejuv /d 160
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIHiddenElements_Rejuv /d 65476
reg add "%WSH%\UI\Visibility" /f /t REG_DWORD /v UIErrorMessageVisibility /d 220
reg add "%WSH%\Cache" /f /t REG_SZ /v "ConfigurationOptionList" /d "{\"ConfigurationOptionList\":[{\"Name\":\"Canary\",\"Alias\":\"Canary Channel\",\"Description\":\"%ccandesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Canary\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%activec%,\"Title\":\"Canary\",\"Warning\":\"%ccanwar%\"},{\"Name\":\"Dev\",\"Alias\":\"Dev Channel\",\"Description\":\"%cdevdesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Dev\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%actived%,\"Title\":\"Dev\",\"Warning\":\"%cdevwar%\"},{\"Name\":\"Beta\",\"Alias\":\"Beta Channel (Recommended)\",\"Description\":\"%cbetadesc%\",\"ContentType\":\"Mainline\",\"Branch\":\"Beta\",\"Ring\":\"External\",\"IsRecommended\":true,\"RecommendedOnly\":false,\"IsValid\":%activeb%,\"Title\":\"Beta\",\"Warning\":\"\"},{\"Name\":\"ReleasePreview\",\"Alias\":\"Release Preview Channel\",\"Description\":\"%crpdesk%\",\"ContentType\":\"Mainline\",\"Branch\":\"ReleasePreview\",\"Ring\":\"External\",\"IsRecommended\":false,\"RecommendedOnly\":false,\"IsValid\":%activerp%,\"Title\":\"Release Preview\",\"Warning\":\"\"}]}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "AccountText" /d "{\"Description\":\"%acdesc%\",\"Title\":\"%actitle%\",\"ButtonTitle\":\"%acbutton%\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "DeviceStatusBarText" /d "{\"Subtitle\":\"%dsdesk%\",\"LinkTitle\":\"%dsltitle%\",\"LinkUrl\":\"https://aka.ms/%Channel%Latest\",\"ButtonUrl\":\"ms-settings:about\",\"Status\":1,\"Title\":\"%dstitle%\",\"ButtonTitle\":\"%dsbutton%\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "ConfigurationExpanderText_Rejuv" /d "{\"Title\":\"%conftitle%\",\"RelatedLinkText\":\"%confrlink%\",\"RelatedLinkUrl\":\"https://github.com/nondetect/ORM-Insider/releases\"}"
reg add "%WSH%\UI\Strings" /f /t REG_SZ /v "UnenrollText_Rejuv" /d "{\"Status\":\"\",\"ToggleTitle\":\"%unrtogtitle%\",\"ToggleDescription\":\"%unrtogdesk%\",\"LinkTitle\":\"%unrlinktitle%\",\"LinkDescription\":\"%unrlinkdesk%\",\"LinkUrl\":\"https://go.microsoft.com/fwlink/?linkid=2136438\",\"Title\":\"%unrtitle%\",\"RelatedLinkText\":\"%unrreltext%\",\"RelatedLinkUrl\":\"https://insider.windows.com/leave-program\"}"
goto :EOF

:STMSG
REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SetupHost.exe" /ve >nul
IF %errorlevel% EQU 0 (set "mcrt=%mcd%") else (set "mcrt=%mce%")
reg add "%WSH%\UI\Strings" /f /v "StickyMessage" /t REG_SZ /d "{\"Message\":\"%mtitle%\",\"LinkTitle\":\"%lm%\",\"LinkUrl\":\"https://github.com/nondetect/offlineinsiderenroll/blob/master/readme.md\",\"DynamicXaml\":\"^<StackPanel xmlns=\\\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\\\"^>^<TextBlock Margin=\\\"0,-25,0,10\\\" Style=\\\"{StaticResource BodyTextBlockStyle }\\\"^>%mdesc% v%scriptver%.^</TextBlock^> ^<TextBlock Margin=\\\"0,0,0,10\\\" Style=\\\"{StaticResource BodyTextBlockStyle }\\\"^>%mcc% [%mkc%] - %mcrt%^</TextBlock^> ^<TextBlock Style=\\\"{StaticResource SubtitleTextBlockStyle }\\\" ^>^<Run FontFamily=\\\"Segoe Fluent Icons\\\"^>^&#xE9D9;^</Run^> ^<Span FontWeight=\\\"SemiBold\\\"^>%mnottitle%^</Span^>^</TextBlock^>^<TextBlock Style=\\\"{StaticResource BodyTextBlockStyle }\\\"^>%mnotdesk1% ^<Span FontWeight=\\\"SemiBold\\\"^>%mnotdesk2%^</Span^>%mnotdesk3% ^<Span FontWeight=\\\"SemiBold\\\"^>%mnotdesk4%^</Span^>.^</TextBlock^>^<Button Command=\\\"{StaticResource ActivateUriCommand}\\\" CommandParameter=\\\"ms-settings:privacy-feedback\\\" Margin=\\\"0,10,0,0\\\"^>^<TextBlock Margin=\\\"5,0,5,0\\\"^>%mnotdesk4%^</TextBlock^>^</Button^>^</StackPanel^>\",\"Severity\":0}"
reg add "%WSH%\UI\Strings" /f /v "StickyXaml" /t REG_SZ /d "<StackPanel xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\"><TextBlock Margin=\"0,10,0,0\" Style=\"{StaticResource BodyTextBlockStyle}\">%mdesc% v%scriptver%. %confrlink%. <Hyperlink NavigateUri=\"https://github.com/nondetect/ORM-Insider/releases\" TextDecorations=\"None\">%lm%</Hyperlink></TextBlock><TextBlock Margin=\"0,10,0,5\" Style=\"{StaticResource SubtitleTextBlockStyle}\"><Run FontFamily=\"Segoe MDL2 Assets\">&#xECA7;</Run> <Span FontWeight=\"SemiBold\">%aco%</Span></TextBlock><TextBlock Style=\"{StaticResource BodyTextBlockStyle }\"><Span FontWeight=\"SemiBold\">%Fancy%</Span></TextBlock><TextBlock Text=\"Channel: %Channel%\" Style=\"{StaticResource BodyTextBlockStyle }\" /><TextBlock Text=\"Content: %Content%\" Style=\"{StaticResource BodyTextBlockStyle }\" /><TextBlock Text=\"%mcc% [%mkc%]: %mcrt%\" Style=\"{StaticResource BodyTextBlockStyle }\" /><TextBlock Margin=\"0,10,0,0\" Style=\"{StaticResource SubtitleTextBlockStyle}\"><Run FontFamily=\"Segoe MDL2 Assets\">&#xE9D9;</Run> <Span FontWeight=\"SemiBold\">%mnottitle%</Span></TextBlock><TextBlock Style=\"{StaticResource BodyTextBlockStyle }\">%mnotdesk1% <Span FontWeight=\"SemiBold\">%mnotdesk2%</Span>. %mnotdesk3% <Span FontWeight=\"SemiBold\">%mnotdesk4%</Span>.</TextBlock><Button Command=\"{StaticResource ActivateUriCommand}\" CommandParameter=\"ms-settings:privacy-feedback\" Margin=\"0,10,0,20\"><TextBlock Margin=\"5,0,5,0\">%mnotdesk4%</TextBlock></Button></StackPanel>"
goto :EOF

:EX_SKIP_CHECK
powershell -command "& { %temp%\sc.cmd install }" 1>NUL 2>NUL
call :STMSG 1>nul 2>nul
del /f /q "%temp%\sc.cmd"
goto :ASK_FOR_REBOOT

:EX_REMOVE_SKIP_CHECK
powershell -command "& { %temp%\sc.cmd remove }" 1>NUL 2>NUL
call :STMSG 1>nul 2>nul
del /f /q "%temp%\sc.cmd"
goto :ASK_FOR_REBOOT

:ENROLL
echo.%agrd%
echo.%apc%
call :RESET_INSIDER_CONFIG 1>NUL 2>NUL
call :ADD_INSIDER_CONFIG 1>NUL 2>NUL
bcdedit /set {current} flightsigning yes >nul 2>&1
echo.%agre%
echo.%apd%
goto :CHECK_CHOICE

:CHECK_CHOICE
echo.%agrd%
echo.%m6%
echo.%agrs%
echo.%me%%m7%
echo.%agre%
echo.%me%%m8%
echo.%agrs%
choice /C:12 /N /M "%mch% [1,2] : "
if errorlevel 2 call :STMSG 1>nul 2>nul & goto:ASK_FOR_REBOOT
if errorlevel 1 goto:EX_SKIP_CHECK

:STOP_INSIDER
echo.%agrd%
echo.%apc%
call :RESET_INSIDER_CONFIG 1>nul 2>nul
bcdedit /deletevalue {current} flightsigning >nul 2>&1
echo.%agre%
echo.%apd%
goto :EX_REMOVE_SKIP_CHECK

:ASK_FOR_REBOOT
echo.%agrd%
echo.%rtitle%
echo.%rdesk%
echo.%agrs%
echo.%me%%m7%
echo.%agre%
echo.%me%%m8%
echo.%agrs%
choice /C:12 /N /M "%mch% [1,2] : "
if errorlevel 2 goto:START_SCRIPT
if errorlevel 1 ( shutdown -r -t 0 )

:AGREEMENT
set "agru=^|              https://github.com/nondetect/ORM-Insider/blob/master/readme.md            ^|"
cls
color c
echo.
echo.%agrt%
echo.
echo.                    %os% %build%
echo.%agrs%
echo.%agr1%
echo.%agre%
echo.%agr2%
echo.%agre%
echo.%agr3%
echo.%agre%
echo.%agru%
echo.%agrd%
echo.%agr4%
echo.%agrd%
echo.%agr5%
echo.%agre%
echo.%agr6%
echo.%agrs%
choice /C:12 /N /M "%mch% [1,2] : "
if errorlevel 2 exit /b
if errorlevel 1 goto:START_SCRIPT

:D_SKIP
set "sclink=https://raw.githubusercontent.com/AveYo/MediaCreationTool.bat/%sk_l%/bypass11/Skip_TPM_Check_on_Dynamic_Update.cmd"
powershell -command "& {Invoke-WebRequest -Uri %sclink% -OutFile %temp%\sc.cmd }" 1>NUL 2>NUL
goto :EOF

:LOCALE
set "agre=^|                                                                                        ^|"
set "agrs=^|----------------------------------------------------------------------------------------^|"
set "agrd=^|========================================================================================^|"
set "me=^|                    ["
set "mc8=v8"
set "mcm=main"
set mkc=%mcm%
set "sk_v8=5e5c2f452dd79cb92833902a1c6a46779fa8c52d"
set "sk_m=main"
set sk_l=%sk_m%
set "defbuild=19042"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
)
for /f "tokens=2-8 delims= " %%a in ('powershell -c "(Get-WmiObject -class Win32_OperatingSystem).Caption"') do set "os=%%a %%b %%c %%d %%e %%f"
for /f "tokens=4-5 delims=[]." %%a in ('ver') do set "build=%%a.%%b"
for /f "tokens=3 delims= " %%a in ('reg query HKLM\SYSTEM\CurrentControlSet\Control\Nls\Language /v Default') do set "lang=%%a"
if /I "%lang%"=="0419"  ( goto :RU_LOCALE ) else ( goto :EN_LOCALE )

:EN_LOCALE
set "chadmin=^|                   This script needs to be executed as an Administrator.                ^|"
set "chbuild=^|      This script is compatible only with Windows 10 v20H2 build %defbuild% and later.       ^|"
set "m1=Enroll to"
set "m2=5] - Disable compatibility check                                   ^|"
set "m3=6] - Enable compatibility check                                    ^|"
set "m4=7] - Stop receiving Insider Preview builds                         ^|"
set "m5=8] - Quit without making any changes                               ^|"
set "m6=^|                    Disable compatibility check?                                        ^|"
set "m7=1] - Yes                                                           ^|"
set "m8=2] - No                                                            ^|"
set "mch=| Enter Your Choice"
set "mcc=Compatibility check"
set "mce=Enabled"
set "mcd=Disabled"
set "apc=^|                    Applying changes...                                                 ^|"
set "apd=^|                    Done                                                                ^|"
set "pte=^| Press any key to exit.                                                                 ^|"
set "rtitle=^|                     A reboot is required to finish applying changes.                   ^|"
set "rdesk=^|                         Do you want restart your computer now?                         ^|"
set "actitle=Windows Insider account"
set "acdesc=No account linked"
set "acbutton=Edit"
set "ccandesc=Ideal for highly technical users. Preview the latest platform changes early in the development cycle. These builds are released with limited documentation, without extensive validation, and can be unstable."
set "ccanwar=..."
set "cdevdesc=Ideal for enthusiasts. Access the latest Windows 11 preview builds as we incubate new ideas and develop long lead features. There will be some rough edges and low stability."
set "cdevwar=We recommend the Dev Channel only if you actively back up your data and are comfortable clean installing Windows. This channel receives builds that may have rough edges or be unstable. Once you install a build from the Dev Channel, the only way to move to another channel or unenroll this device is to clean install Windows. You?ll need to manually back up and restore any data you want to keep."
set "cbetadesc=Ideal for early adopters. These Windows 11 builds will be more reliable than builds from our Dev Channel, with updates validated by Microsoft. Your feedback has the greatest impact here."
set "crpdesk=Ideal if you want to preview fixes and certain key features, plus get optional access to the next version of Windows before it's generally available to the world. This channel is also recommended for commercial users."
set "dstitle=You're on the latest build for your device"
set "dsdesk=Information about the current version is available in the section System - About"
set "dsltitle=Latest build notes"
set "dsbutton=About System"
set "conftitle=Your Insider settings"
set "confrlink=If you want to change settings of the enrollment or stop receiving Insider Preview builds, please use the script."
set "lm=Learn more"
set "mtitle=Device Enrolled using ORM-Insider"
set "mdesc=This device has been enrolled to the Windows Insider program using ORM-Insider"
set "aco=Applied configuration"
set "mnottitle=Telemetry settings notice"
set "mnotdesk1=Windows Insider Program requires diagnostic data collection to be enabled "
set "mnotdesk2=Send optional diagnostic data"
set "mnotdesk3=. You can verify or modify your current settings in "
set "mnotdesk4=Diagnostics and Feedback"
set "unrtitle=Stop getting preview builds"
set "unrtogtitle=Unenroll this device when the next version of Windows releases"
set "unrtogdesk=Available for Beta and Release Preview channels. Turn this on to stop getting preview builds when the next major release of Windows launches to the public. Until then, your device will continue to get Insider builds to keep it secure. You'll keep all your apps, drivers and settings even after you stop getting preview builds."
set "unrlinktitle=Unenroll this device immediately"
set "unrlinkdesk=To stop getting Insider Preview builds on this device, you'll need to clean install the latest release of Windows. Note: This option will erase all your data and install a fresh copy of Windows."
set "unrreltext=Leaving the Insider Program"
set "agrt=                               Agreement of using ORM-Insider"
set "agr1=^|               By using the ORM Insider script, you understand all the risks            ^|"
set "agr2=^|       and any damage to your computer due to lack of compatibility is not covered      ^|"
set "agr3=^|    by the manufacturer's warranty or the authors of this script. Details on the link:  ^|"
set "agr4=^|  By choosing to Accept, you confirm that you have read and understood this agreement.  ^|"
set "agr5=^|                [1] Accept                                                              ^|"
set "agr6=^|                [2] Decline                                                             ^|"
goto :CHECKS

:RU_LOCALE
set "chadmin=^|                      Необходимо запускать от имени Администратора                      ^|"
set "chbuild=^|       Для работы скрипта необходима версия Windows 10 v20H2 сборка %defbuild% или выше      ^|"
set "m1=Перейти на"
set "m2=5] - Отключить проверку совместимости                              ^|"
set "m3=6] - Включить проверку совместимости                               ^|"
set "m4=7] - Прекратить получение Инсайдерских сборок                      ^|"
set "m5=8] - Выход без внесения изменений                                  ^|"
set "m6=^|                    Отключить проверку совместимости?                                   ^|"
set "m7=1] - Да                                                            ^|"
set "m8=2] - Нет                                                           ^|"
set "mch=| Введите свой выбор"
set "mcc=Проверка совместимости"
set "mce=Включена"
set "mcd=Отключена"
set "apc=^|                    Применение изменений...                                             ^|"
set "apd=^|                    Готово                                                              ^|"
set "pte=^| Нажмите любую кнопку для выхода                                                        ^|"
set "rtitle=^|                 Необходима перезагрузка чтобы изменения вступили в силу                ^|"
set "rdesk=^|                        Хотите перезагрузить компьютер сейчас?                          ^|"
set "actitle=Учетная запись участника программы предварительной оценки Windows"
set "acdesc=Нет привязанной учётной записи"
set "acbutton=Изменить"
set "ccandesc=Идеально подходит для технически подкованных пользователей. Предварительно просматривайте новейшие изменения платформы на раннем этапе цикла разработки. Эти сборки выпускаются с ограниченной документацией, без тщательной проверки и могут быть нестабильными."
set "ccanwar=..."
set "cdevdesc=Идеально подходит для энтузиастов. Получайте доступ к новейшим предварительным сборкам Windows 11 по мере формирования новых идей и разработки функций на длительный срок. Вы заметите некоторые шероховатости и низкую стабильность."
set "cdevwar=Мы рекомендуем Dev Channel только в том случае, если вы активно выполняете резервное копирование данных и вам комфортно выполнять чистую установку Windows. Этот канал получает сборки, которые имеют некоторые шероховатости и могут быть нестабильными. После установки сборки из Dev Channel единственный способ перейти на другой канал или отменить регистрацию этого устройства - это выполнить чистую установку Windows. Вам нужно будет вручную создать резервную копию и восстановить все данные, которые вы хотите сохранить."
set "cbetadesc=Идеально подходит для ранних последователей. Эти сборки Windows 11 более надежны, чем сборки из нашего канала Dev, благодаря обновлениям, проверяемым корпорацией Майкрософт. Ваш отзыв оказывает значительное воздействие."
set "crpdesk=Идеально подходит, если вы хотите ознакомиться с исправлениями и некоторыми ключевыми функциями, а также получить возможность доступа к следующей версии Windows, прежде чем она станет общедоступной для всего мира. Этот канал также рекомендуется для коммерческих пользователей."
set "dstitle=На вашем устройстве установлена новейшая версия сборки"
set "dsdesk=Информация о текущей версии доступна в разделе Система - О системе"
set "dsltitle=Последние изменения в сборке"
set "dsbutton=О системе"
set "conftitle=Посмотреть текущие параметры программы предварительной оценки"
set "confrlink=Если хотите изменить настройки Windows Insider или прекратить участие, пожалуйста используйте скрипт"
set "lm=Узнать больше"
set "mtitle=Устройство зарегистрировано с помощью ORM-Insider"
set "mdesc=Это устройство было зарегистрировано в программе предварительной оценки Windows с помощью ORM-Insider"
set "aco=Выбранные настройки"
set "mnottitle=Уведомление о настройках телеметрии"
set "mnotdesk1=Программа предварительной оценки Windows требует, чтобы в настройках сбора диагностических данных была включена"
set "mnotdesk2=Отправка необязательных диагностических данных"
set "mnotdesk3=. Вы можете проверить или изменить свои текущие настройки в"
set "mnotdesk4=Диагностика и Отзывы"
set "unrtitle=Прекратить получение предварительных сборок"
set "unrtogtitle=Отменить регистрацию этого устройства после выхода следующей версии Windows"
set "unrtogdesk=Доступно для каналов бета-версии и предварительного выпуска. Включите этот параметр, чтобы прекратить получение предварительных сборок после запуска следующего общедоступного основного выпуска Windows. До этого момента ваше устройство будет получать сборки для предварительной оценки, чтобы поддерживать его безопасность. Все ваши приложения, драйверы и параметры будут сохранены даже после того, как вы перестанете получать предварительные сборки."
set "unrlinktitle=Быстрая отмена регистрации устройства"
set "unrlinkdesk=Чтобы прекратить получение сборок Insider Preview на устройстве, выполните чистую установку последней версии Windows. Примечание. При этом будут удалены все ваши данные и установлена свежая копия Windows."
set "unrreltext=Выход из программы предварительной оценки Windows"
set "agrt=                           Соглашение об использовании ORM Insider"                                 
set "agr1=^|               Применяя скрипт ORM Insider Вы понимаете все риски и любые               ^|"
set "agr2=^|       повреждения вашего компьютера из-за отсутствия совместимости не покрываются      ^|"
set "agr3=^|         гарантией производителя или авторами данного скрипта. Детали по ссылке:        ^|"
set "agr4=^|         Выбрав Принять, вы подтверждаете, что прочитали и поняли это соглашение.       ^|"
set "agr5=^|                [1] Принять                                                             ^|"
set "agr6=^|                [2] Отказаться                                                          ^|"
goto :CHECKS
