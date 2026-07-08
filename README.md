# MyDrawer

MyDrawer is a lightweight AutoHotkey tray launcher for Windows.

It turns a folder of favorites into a fast tray menu:

- `.lnk` and `.url` shortcuts appear in the top level of the tray menu
- other files appear in the `More` submenu
- left-clicking the tray icon opens the menu
- selecting an item launches the target

## Why Use It

- keeps everyday shortcuts in one tiny tray launcher
- works directly from a normal Windows folder
- uses file and app icons where possible
- has no build step and no packaging overhead

## Requirements

- Windows
- AutoHotkey v1

## Quick Start

1. Run the script:

```powershell
AutoHotkey.exe .\MyDrawer.ahk
```

2. Open the favorites folder:

```text
%AppData%\AHKFavs
```

3. Add the items you want quick access to.
4. Left-click the tray icon to open the menu.

If `.ahk` files are associated with AutoHotkey on your machine, you can also launch `MyDrawer.ahk` by double-clicking it.

## How It Works

On startup the script creates and watches:

```text
%AppData%\AHKFavs
```

Put your favorites there:

- `.lnk` shortcuts
- `.url` shortcuts
- executables
- scripts
- text files
- other frequently opened items

## Menu Layout

- main level: `.lnk` and `.url` entries
- `More`: non-shortcut files
- service actions inside `More`: `Open Shortcut Folder`, `Refresh`, `Exit`, `About`

## Notes

- the script itself is the production artifact
- there is no `.exe` build or release pipeline
- shortcut icons are resolved from the shortcut or its target when possible

## Possible Next Steps

- optional custom tray icon
- optional startup registration
- configurable favorites directory
- duplicate-name handling in the menu

## License

MIT
