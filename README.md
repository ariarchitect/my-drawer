# MyDrawer

MyDrawer is a small AutoHotkey tray launcher for Windows.

It watches a favorites folder in `%AppData%\AHKFavs` and builds a tray menu from the files inside it:

- `.lnk` and `.url` shortcuts appear in the top level of the tray menu
- other files appear in the `More` submenu
- left-clicking the tray icon opens the menu
- selecting an item launches the target

## Requirements

- Windows
- AutoHotkey v1

## Run

Launch the script directly:

```powershell
AutoHotkey.exe .\MyDrawer.ahk
```

You can also associate `.ahk` files with AutoHotkey and run `MyDrawer.ahk` by double-clicking it.

## How It Works

On startup the script creates and uses this folder:

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

Menu behavior:

- top level: shortcut entries (`.lnk`, `.url`)
- `More`: non-shortcut files plus service actions
- service actions: `Open Shortcut Folder`, `Refresh`, `Exit`, `About`

## Project Status

This repository treats the AHK script itself as the production artifact. There is no build step and no `.exe` packaging workflow.

## Roadmap

- optional custom tray icon
- optional startup registration
- configurable favorites directory
- duplicate-name handling in the menu

## License

MIT
