#NoEnv
#SingleInstance, Force
SetBatchLines, -1
SetTitleMatchMode, 2
#Persistent

; === SETTINGS ===
ShortcutsDir := A_AppData . "\AHKFavs"
FileCreateDir, %ShortcutsDir%


; Map menu item text -> full file path
FileMap := {}

; Create More submenu once
Menu, MoreMenu, Add
Menu, MoreMenu, DeleteAll

; Build tray menu first time
Gosub, BuildMenu

; Show tray menu on LEFT click
OnMessage(0x404, "AHK_NOTIFYICON")  ; WM_USER + 4
Return  ; end of auto-execute section


; === LEFT CLICK HANDLER ===
AHK_NOTIFYICON(wParam, lParam) {
    ; WM_LBUTTONUP
    if (lParam = 0x202) {
        Menu, Tray, Show
        return 0
    }
}

GetIconForFile(path) {
    ; Returns [iconFilePath, iconIndex]

    SplitPath, path,,, ext
    StringLower, ext, ext

    if (ext = "lnk") {
        sc := ComObjCreate("WScript.Shell").CreateShortcut(path)
        iconSpec := sc.IconLocation
        target   := sc.TargetPath

        ; If .lnk explicitly specifies an icon:
        if (iconSpec != "") {
            StringSplit, parts, iconSpec, `,
            iconFile := parts1
            iconIndex := parts2

            ; If icon exists AND is NOT an MSI Installer cache icon
            if (FileExist(iconFile) && !InStr(iconFile, "\Installer\")) {
                return [iconFile, iconIndex]
            }
        }

        ; Otherwise use target EXE icon
        ; If the shortcut points to a folder, Menu, Icon can't load it from a directory.
        ; Use a standard folder icon instead.
        if (target != "" && InStr(FileExist(target), "D"))
            return ["shell32.dll", 4]

        ; Otherwise use target icon (exe, etc.) if it exists
        if (target != "" && FileExist(target))
            return [target, 0]

        return ["shell32.dll", 1]
    }

    if (ext = "url") {
        return ["shell32.dll", 14]
    }

    if (ext = "exe") {
        return [path, 0]
    }

    return ["shell32.dll", 1]
}






; === BUILD DYNAMIC TRAY MENU ===
BuildMenu:
    ; Clear tray and More submenu
    Menu, Tray, DeleteAll
    Menu, MoreMenu, DeleteAll

    ; Basic tray settings
    Menu, Tray, NoStandard
    Menu, Tray, Icon, shell32.dll, 44      ; standard Windows 11 icon
    Menu, Tray, Tip, MyDrawer

    FileMap := {}          ; reset mapping
    hasShortcuts := false
    hasMoreFiles := false

    ; Top-level: only shortcuts
    ; Non-shortcut files go into MoreMenu
    Loop, Files, %ShortcutsDir%\*.*, F
	{
		fileName := A_LoopFileName
		fullPath := A_LoopFileFullPath
		ext := A_LoopFileExt
		StringLower, ext, ext

		; Get name without extension
		SplitPath, fileName, , , , nameNoExt

		; Save mapping display name → full path
		FileMap[nameNoExt] := fullPath

		if (ext = "lnk" or ext = "url") {
			Menu, Tray, Add, %nameNoExt%, RunItem
			hasShortcuts := true

			icon := GetIconForFile(fullPath)
			Menu, Tray, Icon, %nameNoExt%, % icon[1], % icon[2]
		} 
		else {
			Menu, MoreMenu, Add, %nameNoExt%, RunItem
			hasMoreFiles := true

			icon := GetIconForFile(fullPath)
			Menu, MoreMenu, Icon, %nameNoExt%, % icon[1], % icon[2]
		}

	}


    ; If there are no shortcuts – show placeholder in tray
    if (!hasShortcuts)
        Menu, Tray, Add, (no shortcuts), NoOp

    ; Separator before "More" submenu
    Menu, Tray, Add

    ; If there were extra files, add a separator in More
    if (hasMoreFiles)
        Menu, MoreMenu, Add

    ; Service items inside More
    Menu, MoreMenu, Add, Open Shortcut Folder, OpenFolder
    Menu, MoreMenu, Add, Refresh, BuildMenu
    Menu, MoreMenu, Add, Exit, DoExit
	Menu, MoreMenu, Add
	Menu, MoreMenu, Add, About, ShowAbout

    ; Attach More submenu to tray
    Menu, Tray, Add, More, :MoreMenu
Return


; === RUN SELECTED FILE ===
RunItem:
    item := A_ThisMenuItem
    fullPath := FileMap[item]
    if (fullPath != "")
        Run, %fullPath%
Return


; === OPEN SHORTCUT FOLDER ===
OpenFolder:
    Run, %ShortcutsDir%
Return


; === DUMMY HANDLER (for "(no shortcuts)") ===
NoOp:
Return

ShowAbout:
Gui, AboutGui:Destroy   ; ensure window does not duplicate
Gui, AboutGui:+AlwaysOnTop +ToolWindow +MinSize300x200
Gui, AboutGui:Margin, 14, 14

Gui, AboutGui:Add, Text, w380,
(
MyDrawer - a quick-access favorites launcher in the system tray.

Usage:
 - Place your .lnk or .url shortcuts in the favorites folder.
 - Shortcuts appear in the top level of the tray menu.
 - Other files (exe, bat, ps1, txt, etc.) appear in the "More" submenu.
 - Left-click the tray icon to open the menu.
 - Selecting an item launches it.

System Commands (in "More"):
 - Open Shortcut Folder - opens the source folder.
 - Refresh - rebuilds the menu.
 - Exit - closes MyDrawer.
 - About - shows this help screen.

Icons:
 - Shortcut icons are taken from their target application when possible.
 - URL shortcuts use the standard web link icon.
 - Executables use their embedded application icons.

Author: Oleg Ariarskiy
Version: 1.1
)

Gui, AboutGui:Add, Button, gCloseAboutGui w100 Center, OK

Gui, AboutGui:Show,, MyDrawer - About
Return

CloseAboutGui:
Gui, AboutGui:Destroy
Return



; === EXIT SCRIPT ===
DoExit:
    ExitApp
Return
