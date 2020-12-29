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

;!include "Sections.nsh"
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

!define INSTALLER_VERSION               '1.0'
!define LIBUSBWIN32_VERSION             '1.2.6.0'

!define PINGUINO_FU_NAME                   'Pinguino-Firmware-Uploader'
!define PINGUINO_FU_ICON                   "pinguino11.ico"
!define PINGUINO_FU_BMP                    "pinguino11.bmp"
!define INSTALLER_NAME                  '${PINGUINO_FU_NAME}-firmware-uploader'
!define FILE_OWNER                      'Pinguino-Firmware-Uploader'
!define FILE_URL                        'https://gitlab.com/2e0byo/pinguino-firmware-uploader/'

!define CURL                            "curl.exe"

!define PBS_MARQUEE                     0x08

!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_PROGRESSBAR   "smooth"
!define MUI_INSTFILESPAGE_COLORS        "00FF00 000000 " ; Green/Black Console Window
!define MUI_ICON                        ${PINGUINO_FU_ICON}
!define MUI_UNICON                      ${PINGUINO_FU_ICON}
!define MUI_WELCOMEFINISHPAGE_BITMAP    ${PINGUINO_FU_BMP}
!define MUI_UNWELCOMEFINISHPAGE_BITMAP  ${PINGUINO_FU_BMP}
;!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_RIGHT
;!define MUI_HEADERIMAGE_BITMAP         ${PINGUINO_FU_BMP}

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT         "Start ${PINGUINO_FU_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION     "LaunchPinguinoIDE"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
;!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.md

!define REG_UNINSTALL                   "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_FU_NAME}"
!define REG_PINGUINO                    "SOFTWARE\${PINGUINO_FU_NAME}"
!define REG_XC8                         "SOFTWARE\Microchip\MPLAB XC8 C Compiler"
!define REG_PYTHON27                    "SOFTWARE\Python\PythonCore\2.7\InstallPath"

!define URL_SFBASE                      "https://sourceforge.net/projects/pinguinoide/files"
!define URL_SFOS                        "${URL_SFBASE}/windows"
!define URL_MCHP                        "http://www.microchip.com"
!define URL_LIBUSB                      "https://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases"
!define URL_PYTHON                      "https://www.python.org/ftp/python"
!define URL_PYTHONPIP                   "https://bootstrap.pypa.io"
!define PyPIP                           "get-pip.py"

!define pinguino-ide                    "pinguino-ide.zip"
!define pinguino-libraries              "pinguino-libraries.zip"
!define pinguino-xc8                    "xc8-v${XC8_VERSION}-full-install-windows-installer.exe"
!define pinguino-xc8-latest             "mplabxc8windows"
!define pinguino-sdcc32                 "pinguino-windows32-sdcc-mpic16.zip"
!define pinguino-sdcc64                 "pinguino-windows64-sdcc-mpic16.zip"
!define pinguino-gcc32                  "pinguino-windows32-gcc-mips-elf.zip"
!define pinguino-gcc64                  "pinguino-windows64-gcc-mips-elf.zip"

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
;Page Custom  PAGE_RELEASE PAGE_RELEASE_LEAVE    ; Which Release ?
;!insertmacro MUI_PAGE_DIRECTORY         ; Install path
;Page Custom  PAGE_COMPILER PAGE_COMPILER_LEAVE  ; Which Compilers ?
!insertmacro MUI_PAGE_INSTFILES         ; Install Pinguino
!insertmacro MUI_PAGE_FINISH            ; End of the installation 

;Uninstaller : *** TODO UNPAGE RELEASE & COMPILERS ***
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
;UninstPage Custom  un.PAGE_RELEASE un.PAGE_RELEASE_LEAVE
!insertmacro MUI_UNPAGE_INSTFILES
;UninstPage Custom  un.PAGE_COMPILER un.PAGE_COMPILER_LEAVE
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
LangString msg_not_detected ${LANG_PORTUGUESEBR} "n�o foi detectado em seu sistema. Instalando ..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando ..."
LangString msg_not_detected ${LANG_FRENCH} "n'a pas �t� trouv�. Installation ..."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "install�"

LangString msg_deleted ${LANG_ENGLISH} "deleted."
LangString msg_deleted ${LANG_SPANISH} "."
LangString msg_deleted ${LANG_PORTUGUESEBR} "."
LangString msg_deleted ${LANG_ITALIAN} "."
LangString msg_deleted ${LANG_FRENCH} "effac�"

LangString msg_downloading ${LANG_ENGLISH} "Downloading"
LangString msg_downloading ${LANG_SPANISH} "Descargado"
LangString msg_downloading ${LANG_PORTUGUESEBR} "Downloading"
LangString msg_downloading ${LANG_ITALIAN} "Downloading"
LangString msg_downloading ${LANG_FRENCH} "T�l�chargement de"

LangString msg_downloaded ${LANG_ENGLISH} "download completed."
LangString msg_downloaded ${LANG_SPANISH} "descargado correctamente."
LangString msg_downloaded ${LANG_PORTUGUESEBR} "download completo."
LangString msg_downloaded ${LANG_ITALIAN} "download completato."
LangString msg_downloaded ${LANG_FRENCH} "t�l�charg�"

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"
LangString msg_your_system_is ${LANG_PORTUGUESEBR} "Seu sistema operacional � pelo menos"
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
LangString msg_uptodate ${LANG_FRENCH} "Votre installation est � jour."

;=======================================================================
;Questions
;=======================================================================

LangString Q_install_release ${LANG_ENGLISH} "Which release of Pinguino do you want to install?"
LangString Q_install_release ${LANG_SPANISH} "Deseas instalar el testing o stable Pinguino IDE?"
LangString Q_install_release ${LANG_PORTUGUESEBR} "Voc� deseja instalar o testing o stable PINGUINO IDE?"
LangString Q_install_release ${LANG_ITALIAN} "Vuoi installare il testing o stable Pinguino?"
LangString Q_install_release ${LANG_FRENCH} "Quelle version de Pinguino voulez-vous installer ?"

LangString Q_install_pinguino ${LANG_ENGLISH} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_SPANISH} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_PORTUGUESEBR} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_ITALIAN} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_FRENCH} "Voulez-vous installer la nouvelle version de Pinguino ?"

LangString Q_install_drivers ${LANG_ENGLISH} "Do you want to install the Pinguino device drivers ?"
LangString Q_install_drivers ${LANG_SPANISH} "Deseas instalar los drivers para la placa Pinguino ahora?"
LangString Q_install_drivers ${LANG_PORTUGUESEBR} "Voc� deseja instalar os Drivers para a placa do Pinguino Agora?"
LangString Q_install_drivers ${LANG_ITALIAN} "Vuoi installare ora i driver per la scheda Pinguino?"
LangString Q_install_drivers ${LANG_FRENCH} "Voulez-vous installer les pilotes USB pour les cartes Pinguino ?"

LangString Q_install_compilers ${LANG_ENGLISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_SPANISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_PORTUGUESEBR} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_ITALIAN} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_FRENCH} "Voulez-vous installer des compilateurs ?"

;=======================================================================
;Errors
;=======================================================================

LangString E_downloading ${LANG_ENGLISH} "download failed. Error was:"
LangString E_downloading ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString E_downloading ${LANG_PORTUGUESEBR} "o download falhou. que pena!, o erro foi:"
LangString E_downloading ${LANG_ITALIAN} "Il download � fallito. L'errore �:"
LangString E_downloading ${LANG_FRENCH} "n'a pu �tre t�l�charg�. Erreur :"

LangString E_extracting ${LANG_ENGLISH} "An error occur while extracting files from"
LangString E_extracting ${LANG_SPANISH} "Se ha producido un error mientras se descomprimia"
LangString E_extracting ${LANG_PORTUGUESEBR} "Houve uma falha no processo de extra��o de arquivos."
LangString E_extracting ${LANG_ITALIAN} "Si e' verificato un errore durante l'estrazione dei file da"
LangString E_extracting ${LANG_FRENCH} "Erreur pendant la d�compression des fichiers de"

LangString E_copying ${LANG_ENGLISH} "An error occur while copying files to"
LangString E_copying ${LANG_SPANISH} "Se ha producido un error mientras se copiaban los archivos en el directorio"
LangString E_copying ${LANG_PORTUGUESEBR} "Um erro ocorreu durante a copia de arquivos para o diret�rio"
LangString E_copying ${LANG_ITALIAN} "Si e' verificato un errore durante la copia dei file in"
LangString E_copying ${LANG_FRENCH} "Erreur lors de la copie des fichiers dans"

LangString E_installing ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_installing ${LANG_SPANISH} "no instalado. El error fue:"
LangString E_installing ${LANG_PORTUGUESEBR} "n�o instalado. o erro foi:"
LangString E_installing ${LANG_ITALIAN} "non installato. L'errore �:"
LangString E_installing ${LANG_FRENCH} "n'a pu �tre install�. Erreur:"

LangString E_starting ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_starting ${LANG_SPANISH} "not installed. Error code was:"
LangString E_starting ${LANG_PORTUGUESEBR} "not installed. Error code was:"
LangString E_starting ${LANG_ITALIAN} "not installed. Error code was:"
LangString E_starting ${LANG_FRENCH} "ne s'est pas install� correctement. Erreur:"

LangString E_failed ${LANG_ENGLISH} "failed. Error code was:"
LangString E_failed ${LANG_SPANISH} "failed. Error code was:"
LangString E_failed ${LANG_PORTUGUESEBR} "failed. Error code was:"
LangString E_failed ${LANG_ITALIAN} "failed. Error code was:"
LangString E_failed ${LANG_FRENCH} "a �chou�. Erreur:"

;=======================================================================
;Variables
;=======================================================================

;Var /GLOBAL os_platform                ; 32- or 64-bit OS
;Var /GLOBAL os_version                 ; Windows XP, Vista, 7, 8 or 10
Var /GLOBAL PINGUINO_FU_RELEASE            ; stable or testing
Var /GLOBAL PINGUINO_FU_VERSION            ; 11 or 12
Var /GLOBAL pinguino_actual_version
Var /GLOBAL pinguino_last_version
Var /GLOBAL SourceForge                 ; Path to SourceForge repository
Var /GLOBAL UserPath                    ; Path to the Pinguino user data
Var /GLOBAL XC8_VERSION                 ; 1.40
Var /GLOBAL XC8_PATH                    ; Path to the XC8 compiler
Var /GLOBAL Python27Path                ; Path to Python 2.7
Var /GLOBAL url                         ; Used by Download Macro
Var /GLOBAL program                     ; Used by Download Macro
;Var hwnd

;=======================================================================
;Delete a file
;=======================================================================

;!macro Remove file
;
;    Delete "$EXEDIR\$file"
;    DetailPrint "$file $(msg_deleted)"
;
;!macroend

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
    Delete "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino-uninstaller.exe"
 
    ;Delete the install directory (but not the compilers)
    RMDir /r /REBOOTOK "$INSTDIR\v$PINGUINO_FU_VERSION\"

    ;Delete the user directory
    RMDir /r /REBOOTOK "$DOCUMENTS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION\"

    ;Delete Desktop Icon
    Delete "$DESKTOP\pinguino-ide.lnk"
    Delete "$DESKTOP\v$PINGUINO_FU_VERSION\${PINGUINO_FU_NAME}.lnk"
    
    ;Delete Program Menu
    RMDir /r "$SMPROGRAMS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION\"
    
    ;Clean the registry base
    DeleteRegKey /ifempty HKCU "${REG_PINGUINO}\v$PINGUINO_FU_VERSION\"
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
    ;SetOutPath $INSTDIR


    ;Install device drivers ?
    MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_drivers)" IDNO NoDrivers
    MessageBox MB_OK|MB_ICONINFORMATION "Note Vendor:Product ID's$\r$\n$\r$\n 8-bit Pinguino : 04D8:FEAA$\r$\n32-bit Pinguino : 04D8:003C" IDNO NoDrivers
    Call InstallLibUSB
    NoDrivers:

    ;Install uploader program

    ;End of installation
    ;Call PublishInfo


SectionEnd

;=======================================================================
;Create a custom page to choose Pinguino release
;=======================================================================

Var RELEASE_STABLE
Var RELEASE_TESTING
Var RELEASE_STATE

Function PAGE_RELEASE

    nsDialogs::Create 1018
    Pop $0
    ${If} $0 == error
        Abort
    ${endif}
    
    !insertmacro MUI_HEADER_TEXT "$(Q_install_release)" ""
    
    ${NSD_CreateRadioButton} 250 75 100% 10u "Stable (v${PINGUINO_FU_STABLE})"
    Pop $RELEASE_STABLE
    
    ${NSD_CreateRadioButton} 250 125 100% 10u "Testing (v${PINGUINO_FU_TESTING})"
    Pop $RELEASE_TESTING

    ${If} $RELEASE_STATE == 1
        ${NSD_SetState} $RELEASE_TESTING  ${BM_SETCHECK}
    ${Else}
        ${NSD_SetState} $RELEASE_STABLE  ${BM_SETCHECK}
    ${endif}

    ${NSD_CreateBitmap} 0 0 100% 50% ""
    Pop $0
    ${NSD_SetImage} $0 "$EXEDIR\${PINGUINO_FU_BMP}" $1
    nsDialogs::Show
    ${NSD_FreeImage} $1

FunctionEnd

Function PAGE_RELEASE_LEAVE

    ${NSD_GetState} $RELEASE_STABLE  $R0
    ${NSD_GetState} $RELEASE_TESTING $R1

    ${If} $R0 == 1

        StrCpy $PINGUINO_FU_VERSION ${PINGUINO_FU_STABLE}
        StrCpy $PINGUINO_FU_RELEASE "stable"
        StrCpy $RELEASE_STATE 1

        StrCpy $INSTDIR "C:\${PINGUINO_FU_NAME}"
        ;DetailPrint "Installation path : $INSTDIR"

    ${Else}

        StrCpy $PINGUINO_FU_VERSION ${PINGUINO_FU_TESTING}
        StrCpy $PINGUINO_FU_RELEASE "testing"
        StrCpy $RELEASE_STATE 1

        ;Detect the architecture of host system (32 or 64 bits)
        ;and set Pinguino default path
        ${If} ${RunningX64}
            ;SetRegView 64
            StrCpy $INSTDIR "$PROGRAMFILES64\${PINGUINO_FU_NAME}"
        ${Else}
            ;SetRegView 32
            StrCpy $INSTDIR "$PROGRAMFILES32\${PINGUINO_FU_NAME}"
        ${endif}
        ;DetailPrint "Installation path : $INSTDIR"

    ${endif}

    StrCpy $UserPath "$DOCUMENTS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION"
    StrCpy $SourceForge "${URL_SFOS}/$PINGUINO_FU_RELEASE"

FunctionEnd

;=======================================================================
;Create a custom page to choose Compilers
;=======================================================================

Var COMPILERS_SDCC
Var COMPILERS_XC8
Var COMPILERS_GCC
 
Function PAGE_COMPILER

    nsDialogs::Create 1018
    Pop $0
    ${If} $0 == error
        Abort
    ${endif}
    
    !insertmacro MUI_HEADER_TEXT "$(Q_install_compilers)" ""
    
    ${NSD_CreateCheckBox} 250 50 100% 10u  "SDCC for PIC18F"
    Pop $COMPILERS_SDCC
    
    ;${If} $PINGUINO_FU_VERSION != "11"
    StrCmp $PINGUINO_FU_VERSION "11" +3
    ${NSD_CreateCheckBox} 250 100 100% 10u "XC8 for PIC16F and PIC18F"
    Pop $COMPILERS_XC8
    
    ${NSD_CreateCheckBox} 250 150 100% 10u "GCC for PIC32MX"
    Pop $COMPILERS_GCC

    ${NSD_CreateBitmap} 0 0 100% 50% ""
    Pop $0
    ${NSD_SetImage} $0 "$EXEDIR\${PINGUINO_FU_BMP}" $1
    nsDialogs::Show
    ${NSD_FreeImage} $1

FunctionEnd

Function PAGE_COMPILER_LEAVE

    ${NSD_GetState} $COMPILERS_SDCC $R0
    StrCmp $PINGUINO_FU_VERSION "11" +2
    ${NSD_GetState} $COMPILERS_XC8  $R1
    ${NSD_GetState} $COMPILERS_GCC  $R2

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
; Python v2.7 detection and installation routine.
;=======================================================================

Function InstallPython

    ;Check the register base if Python is installed
    ;Detect the architecture of host system (32 or 64 bits)
    ${If} ${RunningX64}
        SetRegView 64
    ${Else}
        SetRegView 32
    ${endif}
    ReadRegStr $0 HKLM "${REG_PYTHON27}" ""
    IfErrors 0 Done

    ;Download the Python installer
    DetailPrint "Python v2.7 $(msg_not_detected)"

    ${If} ${RunningX64}
    ${Download} "${URL_PYTHON}/${PYTHON_VERSION}" "python-${PYTHON_VERSION}.amd64.msi"
    ${Else}
    ${Download} "${URL_PYTHON}/${PYTHON_VERSION}" "python-${PYTHON_VERSION}.msi"
    ${endif}

    ;Install Python
    ExecWait '"msiexec" /i "$EXEDIR\$program"' $0
    ${If} $0 != "0"
        Abort "Python v2.7 $(E_installing) $0!"
    ${endif}
    ReadRegStr $0 HKLM "${REG_PYTHON27}" ""
    ;Remove $program
  
    Done:
    DetailPrint "Python v2.7 path is $0"
    DetailPrint "Python v2.7 $(msg_installed)"
    ;StrCpy $Python27Path $0
    ${StrTrim} $Python27Path $0
    
FunctionEnd

;=======================================================================
; Detect, install or upgrade Pip, PySide, PyUSB, Wheel, BeautifullSoup4, Setuptools
; Note Pip is already installed when Python version > 2.7.9.
; The installer just need to update it
;=======================================================================

Function InstallPythonDep

    ;PIP module detection
    IfFileExists "$Python27Path\Scripts\pip.exe" Update +1

    ;Download PIP
    DetailPrint "PyPIP $(msg_not_detected)"
    ;SetOutPath "$TEMP"
    ${Download} ${URL_PYTHONPIP} ${PyPIP}

    ;Install PIP
    ;ExecWait '"$Python27Path\python" "$TEMP\${PyPIP}"' $0
    ExecWait '"$Python27Path\python" "$EXEDIR\${PyPIP}"' $0
    StrCmp $0 "0" Update
    Abort "PyPIP $(E_installing) $0!"
    ;Remove $program

    Update:
    ;Update PIP and dependencies
    ExecWait '"$Python27Path\python" -m pip install --upgrade pip pyside pyusb wheel beautifulsoup4 setuptools requests' $0
    StrCmp $0 "0" Done
    Abort "Python dependencies $(E_installing) $0!"

    Done:
    ;Remove Pinguino's Python package
    DetailPrint "Delete Pinguino's Python package if it exists ..."
    ExecWait '"$Python27Path\python" -m pip --yes uninstall pinguino' $0
    DetailPrint "Python dependencies $(msg_installed)"

FunctionEnd

;=======================================================================
; Install Pinguino last update
;=======================================================================

Function InstallPinguino

    ;get the installed version
    ${If} ${FileExists} "$INSTDIR\v$PINGUINO_FU_VERSION\update-$PINGUINO_FU_RELEASE"
        FileOpen  $0 "$INSTDIR\v$PINGUINO_FU_VERSION\update-$PINGUINO_FU_RELEASE" r
        FileRead  $0 $1
        FileClose $0
        ${StrTrim} $pinguino_actual_version $1
    ${Else}
        ;DetailPrint "*** update not found ***"
        StrCpy $pinguino_actual_version 'unknown'
    ${endif}

    DetailPrint "Pinguino last update $pinguino_actual_version"

    ;get the latest version
    ${Download} ${URL_SFBASE} "update-$PINGUINO_FU_RELEASE"

    ${If} ${FileExists} "$EXEDIR\update-$PINGUINO_FU_RELEASE"
        FileOpen  $0 "$EXEDIR\update-$PINGUINO_FU_RELEASE" r
        FileRead  $0 $1
        FileClose $0
        ${StrTrim} $pinguino_last_version $1
    ${Else}
        StrCpy $pinguino_last_version 'unknown'
    ${endif}

    DetailPrint "Pinguino available update $pinguino_last_version"

    ;compare the 2 versions
    ;StrCmp str1 str2 jump_if_equal [jump_if_not_equal]
    StrCmp $pinguino_last_version 'unknown' StartDownload
    StrCmp $pinguino_actual_version 'unknown' StartDownload
    StrCmp $pinguino_actual_version $pinguino_last_version UpToDate

    StartDownload:

    ;IfFileExists "$INSTDIR\update" 0 +2
    ;Delete "$INSTDIR\update"
    CopyFiles "$EXEDIR\update-$PINGUINO_FU_RELEASE" "$INSTDIR\v$PINGUINO_FU_VERSION\update-$PINGUINO_FU_RELEASE"
    DetailPrint "New version available : $pinguino_last_version"

    Call InstallPinguinoIde
    Call InstallPinguinoLibraries

    UpToDate:
    DetailPrint "$(msg_uptodate)"

FunctionEnd

;=======================================================================
; pinguino-ide installation routine.
;=======================================================================

Function InstallPinguinoIde

    ;Download Pinguino IDE
    ${Download} $SourceForge ${pinguino-ide}

    ;Install Pinguino IDE
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$INSTDIR"
    IfErrors 0 +2
        Abort "$(E_extracting) ${pinguino-ide}"
    DetailPrint "${pinguino-ide} $(msg_installed)"
        
FunctionEnd

;=======================================================================
; pinguino-libraries installation routine.
;=======================================================================

Function InstallPinguinoLibraries

    ;Download Pinguino libraries
    ${Download} $SourceForge ${pinguino-libraries}

    ;Install Pinguino Libraries
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$INSTDIR"
    IfErrors 0 +2
        Abort "$(E_extracting) ${pinguino-libraries}"
    DetailPrint "${pinguino-libraries} $(msg_installed)"

FunctionEnd

;=======================================================================
; Pinguino device driver installation
;=======================================================================

;Function InstallPinguinoDrivers

    ;Copy the drivers directory
    ;SetOutPath "$INSTDIR\drivers"
    ;File /r "drivers\*.*"

    ;Install all the drivers
    ;DetailPrint "$(msg_installing_drivers)..."
    ;nsExec::Exec '"rundll32" syssetup,SetupInfObjectInstallAction DefaultInstall 128 "$INSTDIR\drivers\mchpusb.inf"'
    ;nsExec::Exec '"rundll32" syssetup,SetupInfObjectInstallAction DefaultInstall 128 "$INSTDIR\drivers\mchpcdc.inf"'

    ;MessageBox MB_ICONINFORMATION "The Pinguino Drivers have been installed on your System. If you experience any problem, proceed to a manual installation : go to the drivers directory, right-clic and install mchpusb.inf and mchpcdc.inf"

;FunctionEnd

;=======================================================================
;Install LibUSB and Pinguino Drivers
;=======================================================================

Function InstallLibUSB

    ;Check if LibUSB is installed
    ;ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1" "Inno Setup: App Path"
    ;DetailPrint "LibUSB path is $0"
    ;IfErrors 0 Done

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
    ;ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1\InstallLocation" ""
    ;StrCpy $LibUSBPath $0

FunctionEnd

;=======================================================================
; SDCC compiler installation routine.
;=======================================================================

Function InstallSDCC

    ;Download SDCC
    ${If} ${RunningX64}
    ${Download} ${URL_SFOS} ${pinguino-sdcc64}
    ${Else}
    ${Download} ${URL_SFOS} ${pinguino-sdcc32}
    ${endif}

    ;Install SDCC
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$INSTDIR"
    Pop $0
    StrCmp $0 "success" Done
    Abort "$(E_extracting) $program $0"
    Done:
    DetailPrint "$program $(msg_installed) : $INSTDIR"

FunctionEnd

;=======================================================================
; XC8 compiler installation routine.
;=======================================================================

Function InstallXC8

    ;Download XC8 Installer
    ;StrCpy $url ${URL_SFOS}
    ;StrCpy $program ${pinguino-xc8}
    ${Download} ${URL_MCHP} ${pinguino-xc8-latest}

    ;Run XC8 Installer
    ;nsExec::Exec '"$EXEDIR\${pinguino-xc8}"'
    nsExec::Exec '"$EXEDIR\${pinguino-xc8-latest}"'
    Pop $0
    StrCmp $0 "0" +2
    DetailPrint "XC8 $(E_installing) : $0!"

    ${If} ${RunningX64}
        SetRegView 32
    ${endif}
    ReadRegStr $XC8_VERSION HKLM "${REG_XC8}" "Version"
    ReadRegStr $XC8_PATH HKLM "${REG_XC8}" "Location"
    ${If} ${RunningX64}
        SetRegView 64
    ${endif}
    
    DetailPrint "XC8 v$XC8_VERSION path is $XC8_PATH"
    DetailPrint "XC8 v$XC8_VERSION $(msg_installed)"

FunctionEnd

;=======================================================================
; 32-bits Pinguino compilers installation routine.
;=======================================================================

Function InstallGCC

    ;Download GCC for Pinguino
    ${If} ${RunningX64}
    ${Download} ${URL_SFOS} ${pinguino-gcc64}
    ${Else}
    ${Download} ${URL_SFOS} ${pinguino-gcc32}
    ${endif}

    ;Install GCC for Pinguino
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$INSTDIR"
    Pop $0
    StrCmp $0 "success" Done
    Abort "$(E_extracting) $program $0"
    Done:
    DetailPrint "$program $(msg_installed) : $INSTDIR"
    ;Remove $program

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
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoName" "${PINGUINO_FU_NAME}"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoVersion" "$PINGUINO_FU_VERSION"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoRelease" "$PINGUINO_FU_RELEASE"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoPath" "$INSTDIR"
    WriteRegStr HKLM "${REG_PINGUINO}" "XC8Version" "$XC8_VERSION"
    WriteRegStr HKLM "${REG_PINGUINO}" "XC8Path" "$XC8_PATH"

FunctionEnd

;=======================================================================
; Software shortcuts installation routine.
;=======================================================================

Function MakeShortcuts

    DetailPrint "Adding shortcuts ..."
    ;Extract the icon file to the installation path
    ;/oname change the output name
    File "/oname=$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" ${PINGUINO_FU_ICON}

    ;Create desktop shortcut
    ;CreateShortCut  "$DESKTOP\${PINGUINO_FU_NAME}.lnk" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat" "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|P "Pinguino IDE"
    ;CreateShortCut  "$DESKTOP\${PINGUINO_FU_NAME}-v$PINGUINO_FU_VERSION.lnk" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat" "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|P "Pinguino IDE"
    CreateShortCut  "$DESKTOP\${PINGUINO_FU_NAME}-v$PINGUINO_FU_VERSION.lnk" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat" "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" 0 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino IDE"

    ;Create start-menu items
    CreateDirectory "$SMPROGRAMS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION\"
    CreateShortCut  "$SMPROGRAMS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION\${PINGUINO_FU_NAME}.lnk" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat" "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino IDE"
    CreateShortCut  "$SMPROGRAMS\${PINGUINO_FU_NAME}\v$PINGUINO_FU_VERSION\Uninstall.lnk" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino-uninstall.exe" "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|SHIFT|P "Pinguino Uninstaller"

FunctionEnd

;=======================================================================
; Software Post Install routine.
;=======================================================================

Function InstallComplete

    ;Update pinguino.windows.conf for all windows version
    ;Note that $UserPath could be replaced with %USERNAME% (Dave Maners, 2017-08-13)
    DetailPrint "Updating pinguino.windows.conf ..."
    FileOpen  $0 $INSTDIR\v$PINGUINO_FU_VERSION\pinguino\qtgui\config\pinguino.windows.conf w
    FileWrite $0 "[Paths]$\r$\n"
    FileWrite $0 "sdcc_bin = $INSTDIR\p8\bin\$\r$\n"
    FileWrite $0 "gcc_bin  = $INSTDIR\p32\bin\$\r$\n"
    FileWrite $0 "xc8_bin  = $XC8_PATH\bin$\r$\n"
    FileWrite $0 "pinguino_8_libs  = $INSTDIR\v$PINGUINO_FU_VERSION\p8\$\r$\n"
    FileWrite $0 "pinguino_32_libs = $INSTDIR\v$PINGUINO_FU_VERSION\p32\$\r$\n"
    FileWrite $0 "install_path = $INSTDIR\v$PINGUINO_FU_VERSION\$\r$\n"
    FileWrite $0 "user_path = $UserPath$\r$\n"
    FileWrite $0 "user_libs = $UserPath\pinguinolibs$\r$\n"
    FileClose $0
    
    ;IfFileExists "$Python27Path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf" 0 +2
    ;Delete "$Python27Path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf"
    ;Rename "$INSTDIR\pinguino.windows.conf" "$Python27Path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf"

    ${If} $PINGUINO_FU_VERSION == ${PINGUINO_FU_TESTING}

        ;Update pinguino.bat
        DetailPrint "Updating pinguino.bat ..."
        ;Delete  $INSTDIR\pinguino.bat
        FileOpen  $0 $INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat w
        FileWrite $0 "@ECHO OFF"
        FileWrite $0 "$\r$\n"
        FileWrite $0 "CD $INSTDIR\v$PINGUINO_FU_VERSION"
        FileWrite $0 "$\r$\n"
        ;FileWrite $0 "$Python27Path\python $Python27Path\Scripts\pinguinoide.pyw"
        FileWrite $0 "$Python27Path\python pinguino-ide.py"
        FileWrite $0 "$\r$\n"
        FileClose $0

        ;Execute pinguino-ide post_install routine...
        ExecWait '"$Python27Path\python" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino\pinguino_reset.py"' $0
        StrCmp $0 "0" Done
        DetailPrint "Post-installation $(E_failed) $0!"

    ${Else}
    
        ;Update pinguino.bat
        DetailPrint "Updating pinguino.bat ..."
        ;Delete  $INSTDIR\pinguino.bat
        FileOpen  $0 $INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat w
        FileWrite $0 "@ECHO OFF"
        FileWrite $0 "$\r$\n"
        FileWrite $0 "CD $INSTDIR\v$PINGUINO_FU_VERSION"
        FileWrite $0 "$\r$\n"
        FileWrite $0 "$Python27Path\python pinguino.py"
        FileWrite $0 "$\r$\n"
        FileClose $0

        ;Execute pinguino-ide post_install routine...
        ExecWait '"$Python27Path\python" "$INSTDIR\v$PINGUINO_FU_VERSION\post_install.py"' $0
        StrCmp $0 "0" Done
        DetailPrint "Post-installation $(E_failed) $0!"

    ${endif}
    
    Done:
    DetailPrint "Installation complete."

FunctionEnd

;=======================================================================
; Launch Pinguino IDE
;=======================================================================

Function LaunchPinguinoIDE

    ;StrCmp $PINGUINO_FU_VERSION "11" Start +1
    ;CopyFiles "$Python27Path\Lib\site-packages\pinguino\pinguino.bat" "$INSTDIR\pinguino.bat"
    
    ;Start:
    ExecShell "" "$INSTDIR\v$PINGUINO_FU_VERSION\pinguino.bat"

FunctionEnd
