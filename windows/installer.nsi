;=======================================================================
; Pinguino Firmware Uploader Installation Script
; Hacked from Pinguino IDE NSIS Installation Script v1.7.4 by 2e0byo
; John Maximilian <2e0byo@gmail.com>
;-----------------------------------------------------------------------
; To compile this script you'll need version 3 or above of NSIS :
; http://nsis.sf_url.net/Download
; > makensis(.exe) Pinguino_x.x.x.x.nsi
;=======================================================================

XPStyle on
RequestExecutionLevel admin             ;Request application privileges
SetDatablockOptimize on
SetCompress force
SetCompressor /SOLID lzma
ShowInstDetails show                    ;Show installation logs

;=======================================================================
;Includes
;=======================================================================

!include "WinMessages.nsh"
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

;=======================================================================
;Defines
;=======================================================================

!define INSTALLER_VERSION               '0.0.1.0'
!define LIBUSBWIN32_VERSION             '1.2.6.0'
!define PINGUINO_FU_VERSION             '0.9.1'

!define PINGUINO_FU_NAME                'Pinguino-Firmware-Uploader'
!define PINGUINO_FU_ICON                "pinguino11.ico"
!define PINGUINO_FU_BMP                 "pinguino11.bmp"
!define INSTALLER_NAME                  '${PINGUINO_FU_NAME}-installer'
!define FILE_OWNER                      'Pinguino-Firmware-Uploader'
!define FILE_URL                        'https://github.com/Mad-Wombat-Labs/pinguino-firmware-uploader'
!define GitHub "https://github.com/Mad-Wombat-Labs/pinguino-firmware-uploader/releases/download/"

!define CURL                            "curl.exe"

!define PBS_MARQUEE                     0x08

!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_PROGRESSBAR   "smooth"
!define MUI_INSTFILESPAGE_COLORS        "00FF00 000000 " ; Green/Black Console Window
!define MUI_ICON                        ${PINGUINO_FU_ICON}
!define MUI_UNICON                      ${PINGUINO_FU_ICON}
!define MUI_WELCOMEFINISHPAGE_BITMAP    ${PINGUINO_FU_BMP}
!define MUI_UNWELCOMEFINISHPAGE_BITMAP  ${PINGUINO_FU_BMP}

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT         "Start ${PINGUINO_FU_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION     "LaunchPinguinoFirmwareUploader"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED

!define REG_UNINSTALL                   "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_FU_NAME}"
!define REG_PINGUINO                    "SOFTWARE\${PINGUINO_FU_NAME}"
!define REG_XC8                         "SOFTWARE\Microchip\MPLAB XC8 C Compiler"
!define REG_PYTHON27                    "SOFTWARE\Python\PythonCore\2.7\InstallPath"

!define URL_LIBUSB                      "https://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases"

!define pinguino-fu                      "FirmwareUploader-v${PINGUINO_FU_VERSION}.zip"

;=======================================================================
;General Settings
;=======================================================================

Name                                    '${PINGUINO_FU_NAME}'
;Sets the default value of $INSTDIR, in case no other values can be found.
;InstallDir                              'C:\${PINGUINO_FU_NAME}'
OutFile                                 '${INSTALLER_NAME}-v${INSTALLER_VERSION}.exe'
BrandingText                            '${FILE_URL}'

VIAddVersionKey "ProductName"           '${INSTALLER_NAME}'
VIAddVersionKey "ProductVersion"        '${INSTALLER_VERSION}'
VIAddVersionKey "CompanyName"           '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright"        '2014-2017 ${FILE_OWNER}'
VIAddVersionKey "FileDescription"       'Pinguino IDE & Compilers Installer'
VIAddVersionKey "FileVersion"           '${INSTALLER_VERSION}'
VIProductVersion ${INSTALLER_VERSION}

;=======================================================================
;Pages
;=======================================================================

;Installer
!insertmacro MUI_PAGE_WELCOME           ; Displays a welcome message
!insertmacro MUI_PAGE_LICENSE           "LICENSE"
!insertmacro MUI_PAGE_LICENSE           "DISCLAIMER"
Page Custom  PAGE_RELEASE PAGE_RELEASE_LEAVE    ; Explanatory data (and set path)
!insertmacro MUI_PAGE_DIRECTORY         ; Install path
!insertmacro MUI_PAGE_INSTFILES         ; Install Pinguino
!insertmacro MUI_PAGE_FINISH            ; End of the installation 

;Uninstaller : *** TODO UNPAGE RELEASE & COMPILERS ***
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;=======================================================================
;Languages
;=======================================================================

!insertmacro MUI_LANGUAGE "English"     ; ???
!insertmacro MUI_LANGUAGE "Spanish"     ; Victor Villarreal <mefhigoseth@gmail.com>
!insertmacro MUI_LANGUAGE "PortugueseBR"; Wagner de Queiroz <wagnerdequeiroz@gmail.com>
!insertmacro MUI_LANGUAGE "Italian"     ; Pasquale Fersini <basquale.fersini@gmail.com>
!insertmacro MUI_LANGUAGE "French"      ; Regis Blanchot <rblanchot@pinguino.cc>

;=======================================================================
;Messages
;=======================================================================

LangString msg_not_detected ${LANG_ENGLISH} "not found. Installing it ..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando ..."
LangString msg_not_detected ${LANG_PORTUGUESEBR} "não foi detectado em seu sistema. Instalando ..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando ..."
LangString msg_not_detected ${LANG_FRENCH} "n'a pas été trouvé. Installation ..."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "installé"

LangString msg_deleted ${LANG_ENGLISH} "deleted."
LangString msg_deleted ${LANG_SPANISH} "."
LangString msg_deleted ${LANG_PORTUGUESEBR} "."
LangString msg_deleted ${LANG_ITALIAN} "."
LangString msg_deleted ${LANG_FRENCH} "effacé"

LangString msg_downloading ${LANG_ENGLISH} "Downloading"
LangString msg_downloading ${LANG_SPANISH} "Descargado"
LangString msg_downloading ${LANG_PORTUGUESEBR} "Downloading"
LangString msg_downloading ${LANG_ITALIAN} "Downloading"
LangString msg_downloading ${LANG_FRENCH} "Téléchargement de"

LangString msg_downloaded ${LANG_ENGLISH} "download completed."
LangString msg_downloaded ${LANG_SPANISH} "descargado correctamente."
LangString msg_downloaded ${LANG_PORTUGUESEBR} "download completo."
LangString msg_downloaded ${LANG_ITALIAN} "download completato."
LangString msg_downloaded ${LANG_FRENCH} "téléchargé"

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"
LangString msg_your_system_is ${LANG_PORTUGUESEBR} "Seu sistema operacional é pelo menos"
LangString msg_your_system_is ${LANG_ITALIAN} "Il tuo sistema operativo deve essere almeno"
LangString msg_your_system_is ${LANG_FRENCH} "Votre OS est"

LangString msg_installing_drivers ${LANG_ENGLISH} "Installing the Pinguino drivers"
LangString msg_installing_drivers ${LANG_SPANISH} "Instalando los controladores para el dispositivo Pinguino Project"
LangString msg_installing_drivers ${LANG_PORTUGUESEBR} "Instalando os controladores para o dispositivo do Projeto Pinguino"
LangString msg_installing_drivers ${LANG_ITALIAN} "Sto installando i driver per la scheda Pinguino Project"
LangString msg_installing_drivers ${LANG_FRENCH} "Installation des pilotes Pinguino"

LangString msg_uptodate ${LANG_ENGLISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_SPANISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_PORTUGUESEBR} "Your copy is up to date."
LangString msg_uptodate ${LANG_ITALIAN} "Your copy is up to date."
LangString msg_uptodate ${LANG_FRENCH} "Votre installation est à jour."

;=======================================================================
;Errors
;=======================================================================

LangString E_downloading ${LANG_ENGLISH} "download failed. Error was:"
LangString E_downloading ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString E_downloading ${LANG_PORTUGUESEBR} "o download falhou. que pena!, o erro foi:"
LangString E_downloading ${LANG_ITALIAN} "Il download è fallito. L'errore è:"
LangString E_downloading ${LANG_FRENCH} "n'a pu être téléchargé. Erreur :"

LangString E_extracting ${LANG_ENGLISH} "An error occur while extracting files from"
LangString E_extracting ${LANG_SPANISH} "Se ha producido un error mientras se descomprimia"
LangString E_extracting ${LANG_PORTUGUESEBR} "Houve uma falha no processo de extração de arquivos."
LangString E_extracting ${LANG_ITALIAN} "Si e' verificato un errore durante l'estrazione dei file da"
LangString E_extracting ${LANG_FRENCH} "Erreur pendant la décompression des fichiers de"

LangString E_copying ${LANG_ENGLISH} "An error occur while copying files to"
LangString E_copying ${LANG_SPANISH} "Se ha producido un error mientras se copiaban los archivos en el directorio"
LangString E_copying ${LANG_PORTUGUESEBR} "Um erro ocorreu durante a copia de arquivos para o diretório"
LangString E_copying ${LANG_ITALIAN} "Si e' verificato un errore durante la copia dei file in"
LangString E_copying ${LANG_FRENCH} "Erreur lors de la copie des fichiers dans"

LangString E_installing ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_installing ${LANG_SPANISH} "no instalado. El error fue:"
LangString E_installing ${LANG_PORTUGUESEBR} "não instalado. o erro foi:"
LangString E_installing ${LANG_ITALIAN} "non installato. L'errore è:"
LangString E_installing ${LANG_FRENCH} "n'a pu être installé. Erreur:"

LangString E_starting ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_starting ${LANG_SPANISH} "not installed. Error code was:"
LangString E_starting ${LANG_PORTUGUESEBR} "not installed. Error code was:"
LangString E_starting ${LANG_ITALIAN} "not installed. Error code was:"
LangString E_starting ${LANG_FRENCH} "ne s'est pas installé correctement. Erreur:"

LangString E_failed ${LANG_ENGLISH} "failed. Error code was:"
LangString E_failed ${LANG_SPANISH} "failed. Error code was:"
LangString E_failed ${LANG_PORTUGUESEBR} "failed. Error code was:"
LangString E_failed ${LANG_ITALIAN} "failed. Error code was:"
LangString E_failed ${LANG_FRENCH} "a échoué. Erreur:"

;=======================================================================
;Variables
;=======================================================================

Var /GLOBAL url                         ; Used by Download Macro
Var /GLOBAL program                     ; Used by Download Macro

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY
  InitPluginsDir

  UserInfo::GetAccountType
  pop $0
  ${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
  ${EndIf}

  ;Embed files
  SetOutPath $EXEDIR
  File ${CURL}
  File ${PINGUINO_FU_BMP}

FunctionEnd

Function un.onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;=======================================================================
; Uninstaller Section
;=======================================================================

Section "Uninstall"

  ;Uninstall for all users
  SetShellVarContext all

  ;Always delete uninstaller first
  Delete "$INSTDIR\pinguino-uninstaller.exe"
  
  ;Delete the install directory
  RMDir /r /REBOOTOK "$INSTDIR\"

  ;Delete Desktop Icon
  Delete "$DESKTOP\pinguino-fu.lnk"
  Delete "$DESKTOP\v${PINGUINO_FU_VERSION}\${PINGUINO_FU_NAME}.lnk"
  
  ;Delete Program Menu
  RMDir /r "$SMPROGRAMS\${PINGUINO_FU_NAME}\v${PINGUINO_FU_VERSION}\"
  
  ;Clean the registry base
  DeleteRegKey /ifempty HKCU "${REG_PINGUINO}\v${PINGUINO_FU_VERSION}\"
  DeleteRegKey HKLM "${REG_UNINSTALL}"

SectionEnd

;=======================================================================
; Installer Sections
;=======================================================================

Section "Install"

  ;Install for all users
  SetShellVarContext all

  ;Tells the installer where to extract files
  ;and displays destination in the console window
  SetOutPath $INSTDIR

  ;Install Pinguino Firmware Uploader
  Call InstallPinguinoFU


  ;Install device drivers ?
  MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_drivers)" IDNO NoDrivers
  MessageBox MB_OK|MB_ICONINFORMATION "Either Plug in the device now so it can be detected, or write down the following:$\r$\n$\r$\nNote Vendor:Product ID's$\r$\n$\r$\n 8-bit Pinguino : 04D8:FEAA$\r$\n32-bit Pinguino : 04D8:003C" IDNO NoDrivers
  Call InstallLibUSB
  NoDrivers:

    ;End of installation
    Call PublishInfo
    Call MakeShortcuts
    Call InstallComplete
    
    ;Install uploader program

    WriteUninstaller "$INSTDIR\pinguinofu-uninstall.exe"

SectionEnd

;=======================================================================
; Explanatory page at the beginning
;=======================================================================

Function PAGE_RELEASE

  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${endif}
  
  !insertmacro MUI_HEADER_TEXT "First Arg" "Second Arg"
  
  ${NSD_CreateBitmap} 0 0 100% 50% "Other Arg"
  Pop $0
  ${NSD_SetImage} $0 "$EXEDIR\${PINGUINO_FU_BMP}" $1
  nsDialogs::Show
  ${NSD_FreeImage} $1

FunctionEnd

Function PAGE_RELEASE_LEAVE

  ;Detect the architecture of host system (32 or 64 bits)
  ;and set Pinguino default path
  ${If} ${RunningX64}
    StrCpy $INSTDIR "$PROGRAMFILES64\${PINGUINO_FU_NAME}"
  ${Else}
    StrCpy $INSTDIR "$PROGRAMFILES32\${PINGUINO_FU_NAME}"
  ${endif}

FunctionEnd


;=======================================================================
;Removes leading & trailing whitespace from a string
;=======================================================================

Function StrTrim

  Exch $R1 ; Original string
  Push $R2
  
  Loop:
    StrCpy $R2 "$R1" 1
    StrCmp "$R2" " " TrimLeft
    StrCmp "$R2" "\" TrimLeft
    StrCmp "$R2" "$\r" TrimLeft
    StrCmp "$R2" "$\n" TrimLeft
    StrCmp "$R2" "$\t" TrimLeft
    GoTo Loop2
    
  TrimLeft:   
    StrCpy $R1 "$R1" "" 1
    Goto Loop
    
  Loop2:
    StrCpy $R2 "$R1" 1 -1
    StrCmp "$R2" " " TrimRight
    StrCmp "$R2" "\" TrimRight
    StrCmp "$R2" "$\r" TrimRight
    StrCmp "$R2" "$\n" TrimRight
    StrCmp "$R2" "$\t" TrimRight
    GoTo Done

  TrimRight:  
    StrCpy $R1 "$R1" -1
    Goto Loop2
    
  Done:
    Pop $R2
    Exch $R1

FunctionEnd

!define StrTrim "!insertmacro StrTrim"

!macro StrTrim ResultVar String
  Push "${String}"
  Call StrTrim
  Pop "${ResultVar}"
!macroend

;=======================================================================
;Download a file
;=======================================================================

Function Download

  ; Swap the TOP TWO values of the stack
  Exch
  Pop $url
  Pop $program
  
  Marquee::start /NOUNLOAD /swing /step=1 /scrolls=1 /top=0 /height=18 /width=-1 "$(msg_downloading) $program ..."
  DetailPrint "$(msg_downloading) $program ..."
  Start:
    ClearErrors
    nsExec::ExecToLog '"$EXEDIR\curl.exe" --progress-bar -Lk $url/$program -o "$EXEDIR\$program"'
    Pop $0
    StrCmp $0 "0" Done
    ;Abort "$program $(E_downloading) $0!"
    DetailPrint "$program $(E_downloading) $0!"
    DetailPrint "We try again."
    GoTo Start

  Done:
    DetailPrint "$program $(msg_downloaded)"
    Marquee::stop

FunctionEnd

!define Download "!insertmacro Download"

!macro Download URL PROGRAM
  Push "${URL}"
  Push "${PROGRAM}"
  Call Download
!macroend


;=======================================================================
; pinguino-fu installation routine.
;=======================================================================

Function InstallPinguinoFU
  
  ${Download} "${GitHub}v${PINGUINO_FU_VERSION}" ${pinguino-fu}

  ;Install Pinguino IDE
  ClearErrors
  nsisunz::UnzipToLog "$EXEDIR\${pinguino-fu}" "$INSTDIR"
  IfErrors 0 +2
  Abort "$(E_extracting) ${pinguino-fu}"

  DetailPrint "${pinguino-fu} $(msg_installed)"
  
  Delete "$EXECDIR\${pinguino-fu}"    
  
FunctionEnd

;=======================================================================
;Install LibUSB and Pinguino Drivers
;=======================================================================

Function InstallLibUSB


  ;Download LibUSB
  ${Download} "${URL_LIBUSB}/${LIBUSBWIN32_VERSION}" "libusb-win32-bin-${LIBUSBWIN32_VERSION}.zip"
  
  ;Unzip LibUSB
  ClearErrors
  nsisunz::UnzipToLog "$EXEDIR\$program" "$EXEDIR"
  IfErrors 0 +2
  Abort "$(E_extracting) $program"

  ;Run LibUSB
  nsExec::Exec '"$EXEDIR\libusb-win32-bin-${LIBUSBWIN32_VERSION}\bin\inf-wizard.exe"'
  Pop $0
  StrCmp $0 "0" Done
  Abort "LibUSB $(E_installing) $0!"
  ;Remove $program

  Done:
    DetailPrint "LibUSB $(msg_installed)"

FunctionEnd

;=======================================================================
; Software installation info publish routine.
;=======================================================================

Function PublishInfo

  DetailPrint "Writing Register Database ..."
  ;Uninstall
  WriteRegStr HKCU "Software\${PINGUINO_FU_NAME}" "" "$INSTDIR"
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "${PINGUINO_FU_NAME}"
  WriteRegStr HKLM "${REG_UNINSTALL}" "UninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\""
  WriteRegStr HKLM "${REG_UNINSTALL}" "QuietUninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\" /S"
  WriteRegStr HKLM "${REG_UNINSTALL}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${REG_UNINSTALL}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${REG_UNINSTALL}" "Publisher" "${FILE_OWNER}"
  ;Info
  WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoFUName" "${PINGUINO_FU_NAME}"
  WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoFUVersion" "${PINGUINO_FU_VERSION}"
  WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoFUPath" "$INSTDIR"

FunctionEnd

;=======================================================================
; Software shortcuts installation routine.
;=======================================================================

Function MakeShortcuts

  DetailPrint "Adding shortcuts ..."
  ;Extract the icon file to the installation path
  ;/oname change the output name
  File "/oname=$INSTDIR\pinguino.ico" ${PINGUINO_FU_ICON}

  ;Create desktop shortcut
  CreateShortCut  "$DESKTOP\${PINGUINO_FU_NAME}-v${PINGUINO_FU_VERSION}.lnk" "$INSTDIR\FirmwareUploader.exe" "" "$INSTDIR\pinguino.ico" 0 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino FU"

  ;Create start-menu items
  CreateDirectory "$SMPROGRAMS\${PINGUINO_FU_NAME}\"
  CreateShortCut  "$SMPROGRAMS\${PINGUINO_FU_NAME}\v${PINGUINO_FU_VERSION}\${PINGUINO_FU_NAME}.lnk" "$INSTDIR\FirmwareUploader.exe" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino FU"
  CreateShortCut  "$SMPROGRAMS\${PINGUINO_FU_NAME}\v${PINGUINO_FU_VERSION}\Uninstall.lnk" "$INSTDIR\pinguino-uninstall.exe" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|SHIFT|P "Pinguino FU Uninstaller"

FunctionEnd

;=======================================================================
; Software Post Install routine.
;=======================================================================

Function InstallComplete
  
  Done:
    DetailPrint "Installation complete."

FunctionEnd

;=======================================================================
; Launch Pinguino Firmware Uploader
;=======================================================================

Function LaunchPinguinoFirmwareUploader

  ;Start:
  ExecShell "" "$INSTDIR\FirmwareUploader.exe"

FunctionEnd
