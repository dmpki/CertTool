@echo off
mode con cols=80 lines=36
cd /d %~dp0
chcp 65001 >nul 2>nul
title David Miller Certificate Tool
setlocal EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "color=%%a"
)
setlocal DisableDelayedExpansion
md temp >nul 2>nul
set lineShort=__________________________________________________
set lineLong=_____________________________________________________________
set echoName=true
goto precheck

:precheck
if not exist "%Windir%\System32\certutil.exe" (
	goto precheckFailed
)
goto choice

:choice
set installationMode=
set uninstallationMode=
set precheckFailed=
if %echoName%==true (
	echo.
	echo.
	echo.
	echo                           David Miller Certificate Tool
	set echoName=false
)
echo           %lineLong%
echo.
call :color 0C "               Please disable antivirus software before starting!"
echo.
echo                %lineShort%
echo.
echo                [1] Install root certificates
echo.
echo                [2] Uninstall all certificates
echo.
echo                [3] About CertTool
echo.
echo                [4] Show more options
echo.
echo                [5] Exit
echo           %lineLong%
echo.
set /p mainOption=^>              Please input your choice and press ^"Enter^" ^(1-5^): 
if not defined mainOption (
	set choice=main
	goto invalidOption
)
if %mainOption%==1 (
	set mainOption=
	set installationMode=production
	set installIntermediateCA=false
	goto installationPrecheck
)
if %mainOption%==2 (
	set mainOption=
	set uninstallationMode=all
	goto uninstallation
)
if %mainOption%==3 (
	set mainOption=
	set about=true
	goto credits
)
if %mainOption%==4 (
	set mainOption=
	set echoName=true
	cls
	goto moreChoice
)
if %mainOption%==5 (
	exit
)
set choice=main
set mainOption=
goto invalidOption

:moreChoice
if %echoName%==true (
	echo.
	echo.
	echo.
	echo                           David Miller Certificate Tool
	set echoName=false
)
echo           %lineLong%
echo.
call :color 0C "               Please disable antivirus software before starting!"
echo.
echo                %lineShort%
echo.
echo                [1] Install root and intermediate certificates
echo.
echo                [2] Install test certificates
echo.
echo                [3] Uninstall test certificates
echo.
echo                [4] Return to main menu
echo.
echo                [5] Exit
echo           %lineLong%
echo.
set /p moreOption=^>              Please input your choice and press ^"Enter^" ^(1-5^): 
if not defined moreOption (
	set choice=more
	goto invalidOption
)
if %moreOption%==1 (
	set moreOption=
	set installationMode=production
	set installIntermediateCA=true
	goto installationPrecheck
)
if %moreOption%==2 (
	set moreOption=
	set installationMode=test
	goto testInstallationPrecheck
)
if %moreOption%==3 (
	set moreOption=
	set uninstallationMode=test
	goto testUninstallation
)
if %moreOption%==4 (
	set moreOption=
	set echoName=true
	cls
	goto choice
)
if %moreOption%==5 (
	exit
)
set choice=more
set moreOption=
goto invalidOption

:installationPrecheck
cls
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
if %installIntermediateCA%==true (
	echo                Validating integrity of 15 files...
) else (
	echo                Validating integrity of 5 files...
)
echo.
if not exist "%~dp0cross-sign\R4_R1RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0cross-sign\R4_R2RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0cross-sign\R4_R3RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0root\R4RootCA.reg" (
	goto installationCheckFailed
)
if not exist "%~dp0cross-sign\R4_RootCertificateAuthority.crt" (
	goto installationCheckFailed
)
if %installIntermediateCA%==true (
	if not exist "%~dp0intermediate\ClientAuthCAG4SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\CodeSigningCAG4SHA384.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\DocumentSigningCAG3SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\DVServerCAG5SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\EVServerCAG5SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\ExternalCAG5SHA384.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\InternalPCAG7SHA384.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\OVServerCAG7SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\SecureEmailCAG6SHA256.crt" (
		goto installationCheckFailed
	)
	if not exist "%~dp0intermediate\TimestampingCAG11SHA256.crt" (
		goto installationCheckFailed
	)
)
"%Windir%\System32\certutil.exe" -hashfile "%~dp0cross-sign\R4_R1RootCA.crt" SHA256 > "%~dp0temp\R4_R1RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0cross-sign\R4_R2RootCA.crt" SHA256 > "%~dp0temp\R4_R2RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0cross-sign\R4_R3RootCA.crt" SHA256 > "%~dp0temp\R4_R3RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0root\R4RootCA.reg" SHA256 > "%~dp0temp\R4RootCA.reg.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0cross-sign\R4_RootCertificateAuthority.crt" SHA256 > "%~dp0temp\R4_RootCertificateAuthority.crt.sha256"
if %installIntermediateCA%==true (
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\ClientAuthCAG4SHA256.crt" SHA256 > "%~dp0temp\ClientAuthCAG4SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\CodeSigningCAG4SHA384.crt" SHA256 > "%~dp0temp\CodeSigningCAG4SHA384.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\DocumentSigningCAG3SHA256.crt" SHA256 > "%~dp0temp\DocumentSigningCAG3SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\DVServerCAG5SHA256.crt" SHA256 > "%~dp0temp\DVServerCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\EVServerCAG5SHA256.crt" SHA256 > "%~dp0temp\EVServerCAG5SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\ExternalCAG5SHA384.crt" SHA256 > "%~dp0temp\ExternalCAG5SHA384.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\InternalPCAG7SHA384.crt" SHA256 > "%~dp0temp\InternalPCAG7SHA384.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\OVServerCAG7SHA256.crt" SHA256 > "%~dp0temp\OVServerCAG7SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\SecureEmailCAG6SHA256.crt" SHA256 > "%~dp0temp\SecureEmailCAG6SHA256.crt.sha256"
	"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\TimestampingCAG11SHA256.crt" SHA256 > "%~dp0temp\TimestampingCAG11SHA256.crt.sha256"
)
findstr 5ea2fa33b16f1f12f27653749849a25712b37269ac54ac175374b6e2c687e912 "%~dp0temp\R4_R1RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 6d3917edc8f739c898e244ebb3b7c17c5abd06cb4b597165583656cb1624cbd8 "%~dp0temp\R4_R2RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr ba825cfe7c574a64c50201ece3dcfedcc9263daa2a8fd0c2e7caa200db207843 "%~dp0temp\R4_R3RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 51aa09a59873c7afd4c7a18443a79d16ba832ae2e37bb3513328f9c958c23407 "%~dp0temp\R4RootCA.reg.sha256" >nul 2>nul || goto installationCheckFailed
findstr 4fcb79d8734a74a0247b7fea24bbdd0e01aa3c3f7f9f01f74a2e9f6b13461126 "%~dp0temp\R4_RootCertificateAuthority.crt.sha256" >nul 2>nul || goto installationCheckFailed
if %installIntermediateCA%==true (
	findstr 8025a55ca496abc8ec04760ee198b9c591e7b3fb103450866491a113087fbcda "%~dp0temp\ClientAuthCAG4SHA256.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 808aa0c04928bebd8ba596e662deb5584756ad4951ec927b225dfe2b6e7d9b72 "%~dp0temp\CodeSigningCAG4SHA384.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 03e6cb9dfb0060c4ac36de372946d6bc346aec033a5eda3aabb0abce3f71d6e8 "%~dp0temp\DocumentSigningCAG3SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr f5d4fb98d00068a8105c81f0e9a767c8d7de847366bb7f01fba6b045db73ef96 "%~dp0temp\DVServerCAG5SHA256.crt.sha256"  >nul 2>nul || goto installationCheckFailed
	findstr 088cb36f4d92f25bf4c84b9b3b62c9733edcdc1c66133d8467d769ce543dfea9 "%~dp0temp\EVServerCAG5SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr c212796bd80b0fe9f04de7c67de53eeda50471211b03f32ca6708e047e7af1a2 "%~dp0temp\ExternalCAG5SHA384.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 827b4264775d053a9940c9c7c3e342d79bd5fdcdd75b47931a1f1e0daa5ed22d "%~dp0temp\InternalPCAG7SHA384.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr 23bd7f7468805a6d39359f7e78bd0ac8e35ac3712e5563ba5c83d34047a54858 "%~dp0temp\OVServerCAG7SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr ec853968883fd0e6a628e40548dffde5898ca58ddb262a81e03d5ba50fbae59a "%~dp0temp\SecureEmailCAG6SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
	findstr f60e1e65c1d46089fb9fc3d48ef87b7384eece3fa698b732968861070e1e5da9 "%~dp0temp\TimestampingCAG11SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
)
if %installIntermediateCA%==true (
	echo                All 15 files successfully validated!
) else (
	echo                All 5 files successfully validated!
)
echo                %lineShort%
echo.
goto installation

:installation
echo                Installing Root CA - R1 ^(R4, G2^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0cross-sign\R4_R1RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1AEFDB703481A930A11640F49F148F4F1A1FF1B0" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R2 ^(R4, G2^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0cross-sign\R4_R2RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C0023A4E5FC374DCA1CD4A3472D927EE2EE7D08B" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R3 ^(R4, G2^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0cross-sign\R4_R3RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBF708076234EAE6E9030E939CD886FF3E32CC24" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root CA - R4...
regedit.exe /s "%~dp0root\R4RootCA.reg" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Root Certificate Authority ^(R4, G2^)...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0cross-sign\R4_RootCertificateAuthority.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3E3C4A3E26FF24BA8DFFAD98257471CBFEC4057F" >nul 2>nul || set installationFailed=true
if %installIntermediateCA%==true (
	echo           %lineShort%
	echo.
	echo                Installing Client Authentication CA - G4 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\ClientAuthCAG4SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B814CFEBC99C639682B0A236765535738AAD19A6" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Code Signing CA - G4 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\CodeSigningCAG4SHA384.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A82DACBCC453E4CE514D597BE8CE394AB82D879F" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Document Signing CA - G3 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\DocumentSigningCAG3SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D321B69AC61B3B712ED62BA3901197CF9EC1C106" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing DV Server CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\DVServerCAG5SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E8B7C8713B508BC4A08DEE63A622CD5B0516FDED" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing EV Server CA - G5 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\EVServerCAG5SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F3242F57FAB4AA466E621D4B9080FC12BD7ECD0F" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing External CA - G5 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\ExternalCAG5SHA384.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2E024FED995F43C48461F8547B55A4CE8E586CF6" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Internal PCA - G7 - SHA384...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\InternalPCAG7SHA384.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\06EC516FB31E2BE344EDDFEA2214E059305E3DA4" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing OV Server CA - G7 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\OVServerCAG7SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\AE3BABC8378C3395344B9356060E30E8E05AE5F0" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Secure Email CA - G6 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\SecureEmailCAG6SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\362C650E81F6094EF9AB21131FC05C09480D86F1" >nul 2>nul || set installationFailed=true
	echo.
	echo                Installing Timestamping CA - G11 - SHA256...
	"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\TimestampingCAG11SHA256.crt" >nul 2>nul
	reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04CEEF784BB10EDF59C71A143AF57CD321FC359D" >nul 2>nul || set installationFailed=true
)
if defined installationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:uninstallation
cls
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Removing Root CA - R1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\73298F6468D150007B2EFFFABAAF1956401D0283" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R1 ^(R4, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B569242CF35783FAFEF62AFB9989DBE1175F3A62" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R1 ^(R4, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1AEFDB703481A930A11640F49F148F4F1A1FF1B0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1AEFDB703481A930A11640F49F148F4F1A1FF1B0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1AEFDB703481A930A11640F49F148F4F1A1FF1B0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1AEFDB703481A930A11640F49F148F4F1A1FF1B0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\4A24E7FC6C80EA54BEF5883DD83248F9A1509362" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2 ^(R4, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\852BE1231EF1C9AC3865E69D69843BC1E4818801" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R2 ^(R4, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C0023A4E5FC374DCA1CD4A3472D927EE2EE7D08B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C0023A4E5FC374DCA1CD4A3472D927EE2EE7D08B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C0023A4E5FC374DCA1CD4A3472D927EE2EE7D08B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C0023A4E5FC374DCA1CD4A3472D927EE2EE7D08B" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\26D964969AAC0B5AA7756BDBF00EC82467CDD17F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(R4, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\03CBB967495A68DA5B180DCB728810A77C6E1BA9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R3 ^(R4, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBF708076234EAE6E9030E939CD886FF3E32CC24" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBF708076234EAE6E9030E939CD886FF3E32CC24" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBF708076234EAE6E9030E939CD886FF3E32CC24" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBF708076234EAE6E9030E939CD886FF3E32CC24" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\227A08FD5D7641A2B2D2AB1A4DE00C8AF665BD50" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R1, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\552918E3B7F913232AA7FC07D531F5D03EA113E3" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R1, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EB4A462270C823C28615BC559CF83EED525BA2BA" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EB4A462270C823C28615BC559CF83EED525BA2BA" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EB4A462270C823C28615BC559CF83EED525BA2BA" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EB4A462270C823C28615BC559CF83EED525BA2BA" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R2, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\917E60F37D4C95B1DD26A3BD0CCF690EA220D249" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R2, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\40FBAB3466D71CFB0AB0410CCF31D9BFF88210F0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\40FBAB3466D71CFB0AB0410CCF31D9BFF88210F0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\40FBAB3466D71CFB0AB0410CCF31D9BFF88210F0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\40FBAB3466D71CFB0AB0410CCF31D9BFF88210F0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R3, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B5B3AC85DF129E6D2355384A7808C2CF71558929" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root CA - R4 ^(R3, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1CDFC709BF119D9490557BD80644A37D493240F9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1CDFC709BF119D9490557BD80644A37D493240F9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1CDFC709BF119D9490557BD80644A37D493240F9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1CDFC709BF119D9490557BD80644A37D493240F9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\3D380B6FE804CAE0EF31CE5B4883BDE2D950A21E" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority ^(R1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\88398923B5F33CB231DB9DAD711A137C1B8563A1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority ^(R4, G1^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A68652C2C14CD0A7404E58C72085726602D36EE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Root Certificate Authority ^(R4, G2^)...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3E3C4A3E26FF24BA8DFFAD98257471CBFEC4057F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3E3C4A3E26FF24BA8DFFAD98257471CBFEC4057F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3E3C4A3E26FF24BA8DFFAD98257471CBFEC4057F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3E3C4A3E26FF24BA8DFFAD98257471CBFEC4057F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F518737DB8B5D44357B5A0582791477C3152BFD4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F43C7CAE86044A2E4D6E35AF5C9399D8B15F1880" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\271A3451AA0567DC45B2675FAFE96622EB1474C1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E65B658FECAF89159C1FCAA06CEEFE038E2887AE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EFS CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2A4625D74932A13DAAF47B411FC76EE9E6D6342B" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EFS CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\97FB911E9133C8A2BDE8E45F572C22E64F0BA844" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\87FD477463C7D4830AC8982FA1E12BA02C27ED37" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\86676466785B6F3EA24926AE79ADCC756B61B7D6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\FBEC5EBDDD53C9F94403A384490D1255548945A6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Code Signing CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\194A956FEFA656E0772478A76AB94A81F513FEE0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public RSA CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F7BD40153609E7094BDAC59F4CC349548B484FA0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3576C91ABAA9B39F9DBA384810B19B6B7F80D9E0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Public SHA2 Timestamping CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\746AE0745FF1E6DAC03FF38C59A06873E308EC77" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Open RSA CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1124924F03EA6E52CC54B38BD8DA9D865A6D9157" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing RSA4096 SHA256 Timestamping CA - G6...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAFAB19410C4D343ED24F0A7D138E92FB1EB2BEE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing RSA4096 SHA384 Code Signing CA1 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6E84B61282D7A2ED3DDE8488033B757EECE2B3B6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Client Authentication CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5CE32B0E07CE4B3FB5AE4825AD0AD0E8DECDFE02" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Client Authentication CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\73BA45A24A0FF8857800FA5D420DCE64E714C38B" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4963E0540A1A7F9101FCE7C9983F02AA29E097B6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B541B4D18D119C755B750EA28D410DE3C695404F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\54E992AA87FA67669F890783DAD42D77F124AC59" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\721AC3543D5AF6297C38796E687EE634D66B1BD9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\5A7349FCBD122BF84E2A00B5A0EA4E74561E6E63" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 DV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CD1648DEA60B093672A8CBC9F11A95A7862E0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Document Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\957801A5B6B59A441B61F1B1163BB8F6E29437F3" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC68C2F2A5641D976353FCD92D54B7920A678C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\63DA30C37A9EC7A95FAE37FF7FEF3D85E8A7AD19" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04E1E14E0CD1648AA2FE791EA2E36F7BDC96931E" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\33BB1891420F63AC91349B238EF1D84090078B36" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\14CBA80A1C82E93890DEA20374D12BB0F0D22CCD" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3F6D1ABC45FC22838A95D3FC1B451C17852BCE2D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4D772614849F17C42E707B19200E97A8591EC5C1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\CFDEF3B1192389BC61EE1C6D26615344D948FCEA" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\350E3F3B5C5B43C9587C8601FD070CDDEB28E461" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 OV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\00BA4CCF9D439D1EAFDE5EA13B021CD1DF4BB613" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Mail CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\22730BE91C45B7E4FB3D854A61DB825247F976A9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Email Protection CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1A1238B6EC146C4630482F7356CA58A5267B8040" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Email CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7CA13FF8D8A4EE1607001913598828A9B291238D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E1EFB1300969862E7225086B9288913009684205" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\10F00A2FD1AC37EBB49E58BD7E03F61E175D1564" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Timestamping CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A724DB3FCC09305E9344C34D6773FE37E1E9EF2" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 Timestamping CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\02E9634F821255D60CF199937A62DC022FB302B1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External ECC CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B2B21F6CE7C6F464021D4D0DE75B1CAD2D9AE013" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B2B21F6CE7C6F464021D4D0DE75B1CAD2D9AE013" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B2B21F6CE7C6F464021D4D0DE75B1CAD2D9AE013" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B2B21F6CE7C6F464021D4D0DE75B1CAD2D9AE013" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9BF24354862FC3AA2CECDABE2C0D499FED2CDA9F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\01244CA428A104A8FD6C41B0EA13858489DF60EB" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7A3C6449234457CDED311C616A5D2989617A3267" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\118F70646B14EA96BDD4BE4972F81F3F8B0A81D5" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\965CCCA329763BCD317B8A6F5F26E6ED65001E63" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ED35CD47413428097FAA30698BB54516DFA5DCE7" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\69E92C5D7E030FE6898467262588E84434BE4230" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9DCD649CFBA5ED1C9F99FD131BAB2C2F5F4E8A78" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B5CE8EF0D7A45DB90EE6A710E65417CA904A4E9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EE044237479E0C64AB577E950CAFBA823D1396D6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G5...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\032BDEACB643C633F2632D242B3209F107745921" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC Secure Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\110C3AED5334C79E63135E8F7DA7646B2C391A23" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC Secure Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\80D1F2BDFC55BF9D2BF2808F8DCCBC272ACDF59A" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA2 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6D415D8B211A35E777D32347F6E13D5778A8A795" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A35EFE29FCC310EB1C451EBBF15DCF68D3867441" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC High Assurance Server CA - G3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9A059D7F4FB52FF8E638787E92B0109321815BAE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing High Assurance Code Signing CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BB28E685918A386FDAEAD2FF1FCE9D8D7533DC2B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing High Assurance Code Signing CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2425C624410303E3D305CEB27D7970D04AB5D78F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 EV Code Signing CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\926B14B08E51B20D43DDDDEFFD5E4A8AEEB0470F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\903174AC770839306CE043B6A4EA6FD74AD262C0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 High Assurance Server CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\26087B484C8FB6B569568192569193B50693D977" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing SHA2 High Assurance Server CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\11664106D184F5D3C0487A460DBC55889E36FBA4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Client Authentication CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3CD6E170B9491B7D48C739FAFFC9297DCA1FE8AD" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Client Authentication CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B814CFEBC99C639682B0A236765535738AAD19A6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B814CFEBC99C639682B0A236765535738AAD19A6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B814CFEBC99C639682B0A236765535738AAD19A6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\B814CFEBC99C639682B0A236765535738AAD19A6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G2 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EDD4A7BB0BE7B15F20F7F49519AD31D5AB4DA893" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G3 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\84F765BDD8E712068B296FB09594EA0AAF116E98" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Code Signing CA - G4 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A82DACBCC453E4CE514D597BE8CE394AB82D879F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A82DACBCC453E4CE514D597BE8CE394AB82D879F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A82DACBCC453E4CE514D597BE8CE394AB82D879F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A82DACBCC453E4CE514D597BE8CE394AB82D879F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Document Signing CA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7F9D6BDC5FE8FE59D56863CFAF29BFEDC3D93ECF" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Document Signing CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D321B69AC61B3B712ED62BA3901197CF9EC1C106" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D321B69AC61B3B712ED62BA3901197CF9EC1C106" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D321B69AC61B3B712ED62BA3901197CF9EC1C106" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D321B69AC61B3B712ED62BA3901197CF9EC1C106" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing DV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\ACDC4FEFAA6BB0DEAFB4D1B3CE6B2E7C2D1B52DE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing DV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E8B7C8713B508BC4A08DEE63A622CD5B0516FDED" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E8B7C8713B508BC4A08DEE63A622CD5B0516FDED" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E8B7C8713B508BC4A08DEE63A622CD5B0516FDED" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\E8B7C8713B508BC4A08DEE63A622CD5B0516FDED" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC DV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\671C57EFA9031AAC98406758C96B2C66EF10122F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC EV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EFFF0E2D44A21F20DA9AEEFBF9480BC919A1D661" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing ECC OV Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\961113EBC0FAEB80F5D17F22B67DA53641622B83" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Server CA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EA2F26175237A54066E9AAD9F6D3189B886818E9" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing EV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F3242F57FAB4AA466E621D4B9080FC12BD7ECD0F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F3242F57FAB4AA466E621D4B9080FC12BD7ECD0F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F3242F57FAB4AA466E621D4B9080FC12BD7ECD0F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\F3242F57FAB4AA466E621D4B9080FC12BD7ECD0F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External CA - G4 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8A0105B6F5795E11D1E6AD11A1DF4D7FA7B063C7" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing External CA - G5 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2E024FED995F43C48461F8547B55A4CE8E586CF6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2E024FED995F43C48461F8547B55A4CE8E586CF6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2E024FED995F43C48461F8547B55A4CE8E586CF6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2E024FED995F43C48461F8547B55A4CE8E586CF6" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal PCA - G5 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA6C71CE659F6D3FFB3C2C811107A6B9FD531E8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal PCA - G6 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\170BA85AA19E7FF5CBD89117E54AEAB93AAB7B2C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\170BA85AA19E7FF5CBD89117E54AEAB93AAB7B2C" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\170BA85AA19E7FF5CBD89117E54AEAB93AAB7B2C" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\170BA85AA19E7FF5CBD89117E54AEAB93AAB7B2C" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal PCA - G7 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\06EC516FB31E2BE344EDDFEA2214E059305E3DA4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\06EC516FB31E2BE344EDDFEA2214E059305E3DA4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\06EC516FB31E2BE344EDDFEA2214E059305E3DA4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\06EC516FB31E2BE344EDDFEA2214E059305E3DA4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal Server PCA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8809FB1EC9278061EBFCFBE6A29E95B7E559F1C5" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal Server PCA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\98235A36EE95E971CEE14463057CCA39DE4AD31A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\98235A36EE95E971CEE14463057CCA39DE4AD31A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\98235A36EE95E971CEE14463057CCA39DE4AD31A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\98235A36EE95E971CEE14463057CCA39DE4AD31A" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Internal Server PCA - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\090AD4BF522D71F32A88F314EFD30B34012FF852" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\090AD4BF522D71F32A88F314EFD30B34012FF852" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\090AD4BF522D71F32A88F314EFD30B34012FF852" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\090AD4BF522D71F32A88F314EFD30B34012FF852" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing OV Server CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\BDC027633F1893336C718B1E72738D25CB690704" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing OV Server CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\774B37BFD0CDDFAF8B179809BBADE5BA392B3ADF" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing OV Server CA - G7 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\AE3BABC8378C3395344B9356060E30E8E05AE5F0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\AE3BABC8378C3395344B9356060E30E8E05AE5F0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\AE3BABC8378C3395344B9356060E30E8E05AE5F0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\AE3BABC8378C3395344B9356060E30E8E05AE5F0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Secure Email CA - G5 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1221503CA1E1011B8EB539B15702F3BDBD016CF8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Secure Email CA - G6 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\362C650E81F6094EF9AB21131FC05C09480D86F1" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\362C650E81F6094EF9AB21131FC05C09480D86F1" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\362C650E81F6094EF9AB21131FC05C09480D86F1" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\362C650E81F6094EF9AB21131FC05C09480D86F1" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test DV Server CA - G1 - SHA1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04169974CD77CDDAB83494B8942A7903C5A75696" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G7 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\349084EAD0068C41DB38611E6E20D06C2CA657EE" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G8 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6784D4AC177E0BD6D69E53A7FF608F55AC7C3D3A" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G9 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D508B119C14C83B185A5F7D83309BD4C2874D403" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D508B119C14C83B185A5F7D83309BD4C2874D403" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D508B119C14C83B185A5F7D83309BD4C2874D403" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D508B119C14C83B185A5F7D83309BD4C2874D403" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Timestamping CA - G11 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04CEEF784BB10EDF59C71A143AF57CD321FC359D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04CEEF784BB10EDF59C71A143AF57CD321FC359D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04CEEF784BB10EDF59C71A143AF57CD321FC359D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\04CEEF784BB10EDF59C71A143AF57CD321FC359D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA1 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\0A68740725EFAE8E1553503C0ACE56E4CB638C35" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA1 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7238B2EEEE496AA4D90BDA8BA536982BF8F0E906" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\78077CDEFBA88DB6FD5DCFC9EA7038439A089291" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\325B039AA85A97403B454E33AA6EC1A22B1715B8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA2 - G4 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\2183A69EC5C4BBBDA2DD9F7D65697AAE1115ED77" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA3 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\C4D9738D7CE074777FECA7C4902EEDDFBDDBDA1C" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Global Services CA4 - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\3B89233A57C6EA723CC479F0BBA58709E157818C" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing MitM CA - G1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\021AA04BC0ED7222AF68DA4710711F48C030BDE4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing MitM CA - G2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\51BDB9B4D9F52364A08A642BA86CCB35133BECA4" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Code Signing CA - G1 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Code Signing CA - G2 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing other certificates...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1EE840F63FF22F2A7F324908C0C6763FDD0FABB0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1EE840F63FF22F2A7F324908C0C6763FDD0FABB0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1EE840F63FF22F2A7F324908C0C6763FDD0FABB0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1EE840F63FF22F2A7F324908C0C6763FDD0FABB0" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\6F739F4233ACACFB0A564068CD09CAB6280881C6" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\D126D9AF5C25D69988975750FF5AB680FE49DC46" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\A4605540C381910F27FD63169D6B6E5FD8E54369" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8C5540924A9FFD1193BF8D1716308E92FCB34F81" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\4CA78AF922AE204DF4FEF67C82E45BBBB086CC72" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\8D01F5FF2686520649E9A4BC62BE16D1932D5214" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\85490CF60F531D543F7886050EF1BBE3C7D7942B" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\747D8AF2670696088861EDF31BCBAC662D062E7A" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\2F985221F7BCAFF7A9EF43E640C8FADC437600F0" >nul 2>nul && set uninstallationFailed=true
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\6D518855D3E11B7E7D245CF2A8BB4FFC63064F7E" >nul 2>nul && set uninstallationFailed=true
if defined uninstallationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:openURL
cls
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
echo                         Starting your default browser...
if %url%==pki (
	start https://dmpki.com
	echo                %lineShort%
	echo.
	echo                If the website is not opened,
	echo.
	echo                please enter ^"1^" or open this URL manually:
	echo.
	echo                https://dmpki.com
)
if %url%==dl (
	start https://repo.dmpki.com/CertTool/CertTool.exe
	echo                %lineShort%
	echo.
	echo                If the website is not opened,
	echo.
	echo                please enter ^"1^" or open this URL manually:
	echo.
	echo                https://repo.dmpki.com/CertTool/CertTool.exe
)
echo           %lineLong%
echo.
echo                [1] Reopen URL
echo.
echo                [2] Return to main menu
echo.
echo                [3] Exit
echo           %lineLong%
echo.
set /p openURLOption=^>              Please input your choice and press ^"Enter^" ^(1-3^): 
if not defined openURLOption (
	set echoName=true
	cls
	goto choice
)
if %openURLOption%==1 (
	set openURLOption=
	goto openURL
)
if %openURLOption%==2 (
	set openURLOption=
	set echoName=true
	cls
	goto choice
)
if %openURLOption%==3 (
	exit
)
set openURLOption=
set echoName=true
cls
goto choice

:testInstallationPrecheck
cls
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Validating integrity of 3 files...
echo.
if not exist "%~dp0root\T4RootCA.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0intermediate\TestCodeSigningCAG2SHA384.crt" (
	goto installationCheckFailed
)
if not exist "%~dp0intermediate\TestTimestampingCAG3SHA256.crt" (
	goto installationCheckFailed
)
"%Windir%\System32\certutil.exe" -hashfile "%~dp0root\T4RootCA.crt" SHA256 > "%~dp0temp\T4RootCA.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\TestCodeSigningCAG2SHA384.crt" SHA256 > "%~dp0temp\TestCodeSigningCAG2SHA384.crt.sha256"
"%Windir%\System32\certutil.exe" -hashfile "%~dp0intermediate\TestTimestampingCAG3SHA256.crt" SHA256 > "%~dp0temp\TestTimestampingCAG3SHA256.crt.sha256"
findstr 7c842e48c25ce222b3b7d003c76bd433c2c18a8a34cf73013d67a7298ab4d0f6 "%~dp0temp\T4RootCA.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 97e7c0076208f55f95fa90ee9556d2190ef0924d1d9aa4b11b7e50a2206ec44c "%~dp0temp\TestCodeSigningCAG2SHA384.crt.sha256" >nul 2>nul || goto installationCheckFailed
findstr 02fcb1a53ed79e4cedede2723710ddaba405d92b0e75805e30f46e78c6d950b6 "%~dp0temp\TestTimestampingCAG3SHA256.crt.sha256" >nul 2>nul || goto installationCheckFailed
echo                All 3 files successfully validated!
echo           %lineLong%
echo.
goto testInstallation

:testInstallation
echo                Installing Test Root CA - T4...
"%Windir%\System32\certutil.exe" -addstore ROOT "%~dp0root\T4RootCA.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Test Code Signing CA - G2 - SHA384...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\TestCodeSigningCAG2SHA384.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" >nul 2>nul || set installationFailed=true
echo.
echo                Installing Test Timestamping CA - G3 - SHA256...
"%Windir%\System32\certutil.exe" -addstore CA "%~dp0intermediate\TestTimestampingCAG3SHA256.crt" >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" >nul 2>nul || set installationFailed=true
if defined installationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:testUninstallation
cls
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
echo                Removing Test Root CA - T1...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\1101C8D8663F5EB1BE0925D3195051364E0F0274" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T2...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\38F79C7E2026D4C7556CD1F59A21127A69E37376" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T3...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\BC1845788A6F815B3D82DB0EEBB947755954A01D" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Root CA - T4...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\ROOT\Certificates\E234E4828DD5EC9E726A88ED768AA11582BDA4CC" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Code Signing CA - G1 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\59A06FA24A579CB8491BEE0DC768A18C412947F8" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Code Signing CA - G2 - SHA384...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\7B31818E63A6626BA0E75EA33825B533C71E4236" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G1 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\EAAF5AF802B6A614083F0379616F98A3ADC203D0" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G2 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\1E36060A102FBAA0EC6F6AE8A816A0E4EA53441F" >nul 2>nul && set uninstallationFailed=true
echo.
echo                Removing Test Timestamping CA - G3 - SHA256...
reg delete "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" /f >nul 2>nul
reg delete "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" /f >nul 2>nul
reg query "HKLM\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" >nul 2>nul && set uninstallationFailed=true
reg query "HKCU\SOFTWARE\Microsoft\SystemCertificates\CA\Certificates\9F5D296F72A7E6E2ADBE775CF30F2D3823614457" >nul 2>nul && set uninstallationFailed=true
if defined uninstallationFailed (
	set result=fail
) else (
	set result=success
)
goto credits

:invalidOption
cls
echo.
echo.
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
call :color 0C "                    Your choice is invalid. Please try again"
echo.
if %choice%==precheckFailed (
	echo           %lineLong%
	goto precheckFailedChoice
)
if %choice%==main (
	set echoName=false
	goto choice
)
if %choice%==more (
	goto moreChoice
)
if %choice%==loop (
	exit
)
if %choice%==installationCheckFailed (
	goto installationCheckFailedChoice
)
exit

:precheckFailed
cls
echo.
echo.
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
goto precheckFailedChoice

:precheckFailedChoice
echo.
call :color 0C "                            "certutil.exe" is missing!"
echo.
echo.
call :color 0C "                        CertTool may not work as expected"
echo.
echo                %lineShort%
echo.
echo                [1] Continue using CertTool
echo.
echo                [2] Exit
echo           %lineLong%
echo.
set /p precheckFailedOption=^>              Please input your choice and press ^"Enter^" ^(1-2^): 
if not defined precheckFailedOption (
	set choice=precheckFailed
	goto invalidOption
)
if %precheckFailedOption%==1 (
	set echoName=true
	cls
	goto choice
)
if %precheckFailedOption%==2 (
	exit
)
set choice=more
set moreOption=
goto invalidOption

:installationCheckFailed
cls
echo.
echo.
echo.
echo                           David Miller Certificate Tool
echo           %lineLong%
echo.
call :color 0C "                      Some files are missing or corrupted!"
echo.
goto installationCheckFailedChoice

:installationCheckFailedChoice
echo                %lineShort%
echo.
echo                [1] Re-download CertTool
echo.
echo                [2] Continue installing
echo.
echo                [3] Return to main menu
echo.
echo                [4] Exit
echo           %lineLong%
echo.
set /p installationCheckFailedOption=^>              Please input your choice and press ^"Enter^" ^(1-4^): 
if not defined installationCheckFailedOption (
	set choice=installationCheckFailed
	goto invalidOption
)
if %installationCheckFailedOption%==1 (
	set url=dl
	goto openURL
)
if %installationCheckFailedOption%==2 (
	set installationCheckFailedOption=
	cls
	echo.
	echo                           David Miller Certificate Tool
	echo           %lineLong%
	echo.
	if %installationMode%==production (
		goto installation
	) else (
		goto testInstallation
	)
)
if %installationCheckFailedOption%==3 (
	set installationCheckFailedOption=
	cls
	set echoName=true
	goto choice
)
if %installationCheckFailedOption%==4 (
	exit
)
set choice=installationCheckFailed
set installationCheckFailedOption=
goto invalidOption         

:credits
if defined about (
	set result=about
	cls
	echo.
	echo.
	echo.
	echo                           David Miller Certificate Tool
	echo           %lineLong%
	echo.
	echo                CertTool provides the easiest and the safest way
	echo.
	echo                to trust David Miller Trust Services certificates.
)
echo           %lineLong%
if %result%==fail (
	echo.
	call :color 0C "               Failed!"
	echo.
)
if %result%==success (
	echo.
	call :color 0C "               Finished!"
	echo.
)
echo.
if defined uninstallationFailed (
	call :color 0C "               Some certificates are not removed from your device!"
	echo.
	echo.
)
if defined installationFailed (
	call :color 0C "               Some certificates are not installed on your device!"
	echo.
	echo.
)
set uninstallationFailed=
set installationFailed=
echo                Author: David Miller Trust Services Team
echo.
echo                Website: https://dmpki.com
echo.
echo                Version: 2.17 ^(Release^)
echo.
echo                © 2025 David Miller Trust Services. All rights reserved.
if defined about (
	setlocal EnableDelayedExpansion
	set result=
	set about=
	echo           !lineLong!
	echo.
	echo                [1] Visit our website
	echo.
	echo                [2] Return to main menu
	echo.
	echo                [3] Exit
	echo           !lineLong!
	echo.
	set /p aboutOption=^>              Please input your choice and press ^"Enter^" ^(1-3^): 
	if not defined aboutOption (
		set echoName=true
		cls
		setlocal DisableDelayedExpansion
		goto choice
	)
	if !aboutOption!==1 (
		set aboutOption=
		set url=pki
		setlocal DisableDelayedExpansion
		goto openURL
	)
	if !aboutOption!==2 (
		set aboutOption=
		set echoName=true
		setlocal DisableDelayedExpansion
		cls
		goto choice
	)
	if !aboutOption!==3 (
		exit
	)
	set echoName=true
	cls
	goto choice
)

:loopChoice
echo           %lineLong%
echo.
echo                [1] Return to main menu
echo.
setlocal EnableDelayedExpansion
if !result!==success (
	echo                [2] About
	echo.
	echo                [3] Exit
	echo           !lineLong!
	echo.
	set /p loopOption=^>              Please input your choice and press ^"Enter^" ^(1-3^): 
	if not defined loopOption (
		set choice=loop
		goto invalidOption
	)
	if !loopOption!==1 (
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		cls
		goto choice
	)
	if !loopOption!==2 (
		set loopOption=
		set about=true
		setlocal DisableDelayedExpansion
		goto credits
	)
	if !loopOption!==3 (
		exit
	)
)
if !result!==fail (
	if defined installationMode (
		echo                [2] Retry installation
	) else (
		echo                [2] Retry uninstallation
	)
	echo.
	echo                [3] Open Certificate Manager Tool ^(Local Machine^)
	echo.
	echo                [4] Open Certificate Manager Tool ^(Current User^)
	echo.
	echo                [5] About
	echo.
	echo                [6] Exit
	echo           !lineLong!
	echo.
	set /p loopOption=^>              Please input your choice and press ^"Enter^" ^(1-6^): 
	if not defined loopOption (
		set choice=loop
		goto invalidOption
	)
	if !loopOption!==1 (
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		cls
		goto choice
	)
	if !loopOption!==2 (
		cls
		set result=
		set echoName=true
		set loopOption=
		if !installationMode!==production (
			setlocal DisableDelayedExpansion
			goto installationPrecheck
		)
		if !installationMode!==test (
			setlocal DisableDelayedExpansion
			goto testInstallationPrecheck
		)
		if !uninstallationMode!==all (
			setlocal DisableDelayedExpansion
			goto uninstallation
		)
		if !uninstallationMode!==test (
			setlocal DisableDelayedExpansion
			goto testUninstallation
		)
	)
	if !loopOption!==3 (
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		start certlm.msc
		cls
		goto choice
	)
	if !loopOption!==4 (
		set result=
		set echoName=true
		set loopOption=
		setlocal DisableDelayedExpansion
		start certmgr.msc
		cls
		goto choice
	)
	if !loopOption!==5 (
		set loopOption=
		set about=true
		setlocal DisableDelayedExpansion
		goto credits
	)
	if !loopOption!==6 (
		exit
	)
)
set choice=loop
set loopOption=
goto invalidOption

:color
<nul set /p ".=%color%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof