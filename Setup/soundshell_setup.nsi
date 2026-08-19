!define PRODUCT_NAME "SoundShell"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "Sibra-Soft"
!define PRODUCT_WEB_SITE "https://www.audiostation.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\SoundShell.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON ".\program.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

!define MUI_HEADERIMAGE_BITMAP ".\header.bmp"
!define MUI_UI_HEADERIMAGE_RIGHT ".\header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP ".\wizard.bmp"
!define MUI_COMPONENTSPAGE_NODESC

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\SoundShell.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

RequestExecutionLevel admin

Name "${PRODUCT_NAME}"
OutFile "sound_shell_windows_setup.exe"
InstallDir "$PROGRAMFILES\Sibra-Soft\SoundShell"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "!SoundShell" SEC_main
  SetOverwrite ifnewer
  SetOverwrite try

  CreateDirectory "$SMPROGRAMS\SoundShell"

  SetOutPath "$INSTDIR\pt-PT"
  File "..\bin\Publish\pt-PT\Terminal.Gui.resources.dll"
  SetOutPath "$INSTDIR\fr-FR"
  File "..\bin\Publish\fr-FR\Terminal.Gui.resources.dll"
  SetOutPath "$INSTDIR\ja-JP"
  File "..\bin\Publish\ja-JP\Terminal.Gui.resources.dll"
  SetOutPath "$INSTDIR\runtimes\win\lib\net9.0"
  File "..\bin\Publish\runtimes\win\lib\net9.0\System.Management.dll"
  SetOutPath "$INSTDIR"
  File "..\bin\Publish\NAudio.Asio.dll"
  File "..\bin\Publish\NAudio.Core.dll"
  File "..\bin\Publish\NAudio.dll"
  File "..\bin\Publish\NAudio.Midi.dll"
  File "..\bin\Publish\NAudio.Wasapi.dll"
  File "..\bin\Publish\NAudio.WinMM.dll"
  File "..\bin\Publish\NStack.dll"
  File "..\bin\Publish\SoundShell.deps.json"
  File "..\bin\Publish\SoundShell.dll"
  File "..\bin\Publish\SoundShell.exe"
  File "..\bin\Publish\SoundShell.runtimeconfig.json"
  File "..\bin\Publish\System.CodeDom.dll"
  File "..\bin\Publish\System.Management.dll"
  File "..\bin\Publish\Terminal.Gui.dll"
SectionEnd

Section "Start Menu Shortcuts" SEC02
  CreateShortCut "$SMPROGRAMS\SoundShell\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut "$SMPROGRAMS\SoundShell\SoundShell.lnk" "$INSTDIR\SoundShell.exe"
SectionEnd

Section "Desktop Shortcut" SEC03
  CreateShortCut "$DESKTOP\SoundShell.lnk" "$INSTDIR\SoundShell.exe"
SectionEnd

Section -Post
   WriteUninstaller "$INSTDIR\uninst.exe"
   WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\SoundShell.exe"
   
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\SoundShell.exe"
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
   WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\pt-PT\Terminal.Gui.resources.dll"
  Delete "$INSTDIR\fr-FR\Terminal.Gui.resources.dll"
  Delete "$INSTDIR\ja-JP\Terminal.Gui.resources.dll"
  Delete "$INSTDIR\runtimes\win\lib\net9.0\System.Management.dll"
  Delete "$INSTDIR\NAudio.Asio.dll"
  Delete "$INSTDIR\NAudio.Core.dll"
  Delete "$INSTDIR\NAudio.dll"
  Delete "$INSTDIR\NAudio.Midi.dll"
  Delete "$INSTDIR\NAudio.Wasapi.dll"
  Delete "$INSTDIR\NAudio.WinMM.dll"
  Delete "$INSTDIR\NStack.dll"
  Delete "$INSTDIR\SoundShell.deps.json"
  Delete "$INSTDIR\SoundShell.dll"
  Delete "$INSTDIR\SoundShell.exe"
  Delete "$INSTDIR\SoundShell.runtimeconfig.json"
  Delete "$INSTDIR\System.CodeDom.dll"
  Delete "$INSTDIR\System.Management.dll"
  Delete "$INSTDIR\Terminal.Gui.dll"
  
  RMDir "$INSTDIR\runtimes\win\lib\net9.0"
  RMDir "$INSTDIR\pt-PT"
  RMDir "$INSTDIR\ja-JP"
  RMDir "$INSTDIR\fr-FR"
  RMDir "$INSTDIR"
  
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
  SetAutoClose true
SectionEnd