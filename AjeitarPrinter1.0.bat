:: Permitir logon com usuário com senha em branco: Configuração do Computador > Modelos Administrativos > Rede > Estação de trabalho LANMAN > Habilitar logons de convidados não seguros
:: Editor de Política de Grupo > Configuração do Computador > Modelos Administrativos > Impressoras > opção Definir configurações de conexão RPC e habilitar a opção RPC sobre pipes nomeados (ao invés de RPC sobre TCP). Daí clique em Aplicar e OK e reinicie o PC..

@Echo On
Title Meadow Tecnologia - AjeitaPrinter 1.0 & Color 7
cd %systemroot%\system32
call :IsAdmin

cls
@echo  -=[ Meadow Tecnologia - AjeitaPrint v1.0 - 31/10/2023 ]=-
@echo Desenvolvido por Bruno Tavares   meadowtecnologia@gmail.com
@echo . 
@echo #############################
@echo # USE POR SUA CONTA E RISCO #
@echo #############################
@echo .
@echo Se apos rodar o script nao der certo, execute estes procedimentos:
@echo .
@echo 1 - Ativar compartilhamento protegido por senha
@echo .
@echo 2 - Executar Solucao de Problemas (parece obvio, mas ja resolveu meu problema)
@echo .
@echo 3 - Inserir senha no Usuario do Windows (resolve muitas vezes tambem)
@echo .
@echo 4 - Tentar conexao por IP ou nome (ao inves de \\NomedoPC use \\IPdoPC)
@echo .
@echo 5 - Anti-virus bloqueando o trafego impressoras (Desabilite o anti-virus, em ultimo caso desinstale)
@echo .
@echo 6 - Ativar descoberta de rede
@echo .
@echo 7 - Setar impressora como padrao e reiniciar o computador
@echo .
@echo 8 - Desabilitar usuario convidado (para Windows 10 e 11)
@echo .
@echo LEMBRE-SE DE REINICIAR O COMPUTADOR APOS EXECUTAR ESTE SCRIPT. E FUNDAMENTAL!
@echo RODE O SCRIPT PRIMEIRO NA MAQUINA ONDE ESTA INSTALADA A IMPRESSORA, SE NAO RESOLVER RODE NAS OUTRAS MAQUINAS

pause

:: Procedimento 01
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "1921033356" /t REG_DWORD /d "0" /f

:: Procedimento 02
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "713073804" /t REG_DWORD /d "0" /f

:: Procedimento 03
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v "3598754956" /t REG_DWORD /d "0" /f

: Procedimento 04
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f

:: Procedimento 05
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcProtocols /t REG_DWORD /d 0x7 /f

:: Procedimento 06
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcTcpPort /t REG_DWORD /d <port number> /f

:: Procedimento 07
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v ForceKerberosForRpc /t REG_DWORD /d 1 /f

:: Procedimento 08
netsh int ip show excludedportrange tcp
netsh int ip show excludedportrange udp
netsh int ipv4 add excludedportrange tcp startport=50000 numberofports=225
netsh int ipv4 add excludedportrange udp startport=50000 numberofports=225
netsh int ipv6 add excludedportrange tcp startport=50000 numberofports=225
netsh int ipv6 add excludedportrange udp startport=50000 numberofports=225

:: Procedimento 09
netsh int ipv4 show dynamicport tcp
netsh int ipv4 show dynamicport udp
netsh int ipv4 set dynamicportrange tcp startport=50000 numberofports=255
netsh int ipv4 set dynamicportrange udp startport=50000 numberofports=255
netsh int ipv6 set dynamicportrange tcp startport=50000 numberofports=255
netsh int ipv6 set dynamicportrange udp startport=50000 numberofports=255

:: Procedimento 10
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v "RestrictDriverInstallationToAdministrators" /t REG_DWORD /d "0" /f

:: Procedimento 11
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "RpcAuthnLevelPrivacyEnabled" /t REG_DWORD /d "0" /f

:: Procedimento 12
@echo off
net  stop  spooler
takeown  /F  C:\Windows\System32\Spool\Printers  /R
icacls  C:\Windows\System32\Spool\Printers  /T  /Grant Everyone:F
del  /Q  C:\Windows\System32\Spool\Printers\*.*
net  start  spooler

:: Procedimento 13
@echo off
net stop spooler
timeout -t 3 -NOBREAK
echo.
del %windir%\system32\spool\printers\*.* /q /s
net start spooler

:: Procedimento 14
wusa /uninstall /kb:5004945
timeout -t 5 -NOBREAK

:: Procedimento 15
@ECHO Off
    SET /P yesno=Gostaria de reiniciar o computador agora? Muito Recomendavel [S ou enter/N]:
    IF "%yesno%"=="S" GOTO Confirmation
    IF "%yesno%"=="s" GOTO Confirmation
    IF "%yesno%"=="n" GOTO End
    IF "%yesno%"=="N" GOTO End
    
    :Confirmation
    
    ECHO O sistema sera reiniciado agora!
    
    shutdown.exe /r /t 00
    
    GOTO EOF
    :End
    
    ECHO Reiniciamento cancelado.
    
    TIMEOUT 2 >nul
    
    :EOF
exit

:IsAdmin
Reg.exe query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
 Cls & echo Execute este aplicativo como administrador ... 
 Pause & Exit
)
Cls
goto:eof
