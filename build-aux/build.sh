#!/usr/bin/env bash
set -e

# Go to project root
cd "$(dirname "$0")/.."

# Detect OS
OS=$(uname -s)

# Clean function
function clean_build() {
    echo "🧹 Cleaning build artifacts..."
    rm -rf build dist *.spec AppDir

    if [[ "$OS" == "Linux" ]]; then
        echo "🧹 Removing AppImage(s)..."
        rm -f ./*.AppImage
    fi

    echo "✅ Clean completed."
    exit 0
}

# Handle "clean" argument
if [[ "$1" == "clean" ]]; then
    clean_build
fi

echo "🔍 Detected OS: $OS"
case "$OS" in
    Linux)
        echo "✅ Linux detected. Will build and package AppImage."
        ;;
    Darwin)
        echo "✅ macOS detected. Will build standalone macOS app with PyInstaller."
        ;;
    MINGW*|CYGWIN*|MSYS*|Windows_NT)
        echo "✅ Windows detected. Will build Windows executable with PyInstaller."
        ;;
    *)
        echo "❌ Unsupported OS: $OS"
        exit 1
        ;;
esac

# Setup Python virtual environment
if [[ ! -d venv ]]; then
    echo "🐍 Creating virtual environment..."
    python -m venv venv
fi

echo "📦 Activating virtual environment..."
case "$OS" in
    MINGW*|MSYS*|CYGWIN*)
        source venv/Scripts/activate
        ;;
    *)
        source venv/bin/activate
        ;;
esac

# Install dependencies
echo "📦 Installing dependencies from requirements.txt..."
pip install -r requirements.txt

echo "📦 Installing PyInstaller..."
pip install pyinstaller
#pip install Pillow


# Build with PyInstaller
echo "⚙️ Building with PyInstaller..."
pyinstaller \
  --noconfirm \
  --onefile \
  --windowed \
  --name wuwa-simple-fps-unlocker \
  --icon='share/icons/hicolor/32x32/apps/wuwa-simple-fps-unlocker.png' \
  --add-data "share/icons/hicolor/32x32/apps/wuwa-simple-fps-unlocker.png:share/icons/hicolor/32x32/apps" \
  --strip \
  --clean \
  src/main.py

# AppImage build on Linux
if [[ "$OS" == "Linux" ]]; then
    echo "📦 Preparing AppImage..."

    # Download linuxdeploy if not present
    if [[ ! -f linuxdeploy-x86_64.AppImage ]]; then
        echo "⬇️ Downloading linuxdeploy..."
        wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
        chmod +x linuxdeploy-x86_64.AppImage
    else
        echo "✅ linuxdeploy already present."
    fi

    echo "🚀 Generating AppImage..."
    ./linuxdeploy-x86_64.AppImage \
      --appdir AppDir \
      --executable dist/wuwa-simple-fps-unlocker \
      --desktop-file share/applications/wuwa-simple-fps-unlocker.desktop \
      --icon-file share/icons/hicolor/256x256/apps/wuwa-simple-fps-unlocker.png \
      --output appimage

    mv WuWaSimpleFPSUnlocker-x86_64.AppImage dist/

    echo "🎉 AppImage created successfully."
fi

echo "✅ Build process completed."
