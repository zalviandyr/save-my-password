# Save My Password - Windows

## Feature

- CRUD account (SQLite)
- Backup restore (CSV)
- Filter

## Usage

- Clone this repository
- Open with VSCode
- Download all dependencies
  ```bash
  > flutter packages get
  ```
- Build
  ```bash
  > flutter build windows
  ```
- Download `sqlite3.dll` in this [link](https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll)
- Copy `sqlite3.dll` to `build\windows\runner\Release\`
- Execute application in folder
  `build\windows\runner\Release\save_my_password.exe`
