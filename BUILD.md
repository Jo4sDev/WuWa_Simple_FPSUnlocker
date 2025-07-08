## ⚙️ Build Instructions

This project includes a helper script to build the application for Windows, Linux, and macOS using [PyInstaller](https://www.pyinstaller.org/).  
On Linux, it also packages the application as an [AppImage](https://appimage.org/) using [`linuxdeploy`](https://github.com/linuxdeploy/linuxdeploy), a modular AppImage creation tool.
---

### ✅ Requirements

- Python 3.8+ installed
- A working terminal (`bash`)
- Optional: virtual environment support (recommended)

---

### 📦 Dependencies

Your Python dependencies should be listed in `requirements.txt`.  
Make sure your system has:

- `python3-venv` package (for creating virtual environments)
- On **Linux**, `python3-tk` must be installed (`tkinter` dependency)
  - **Debian/Ubuntu**: `sudo apt install python3-tk`
  - **Arch/Manjaro**: `sudo pacman -S tk`

---

## 🚀 Building the Application

From the root of the project, run:

```bash
./build-aux/build.sh
```

This will:

1.  Create a Python virtual environment (`venv/`) if missing
    
2.  Install `tkinter`, `pyinstaller` and `requirements.txt`
    
3.  Generate a single-file executable using PyInstaller:
    
    -   `dist/wuwa-simple-fps-unlocker` (Linux/macOS)
        
    -   `dist/wuwa-simple-fps-unlocker.exe` (Windows)
        
4.  On Linux: also generate an `.AppImage`
    
---

## 🧹 Cleaning the Build

To remove all build artifacts, run:

```bash
./build-aux/build.sh clean
```

This will remove:

-   `build/`, `dist/`, `*.spec` 
-   AppDir folder    
-   Any generated `.AppImage` (on Linux)
